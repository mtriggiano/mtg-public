# frozen_string_literal: true

class ExpedientArrival < ApplicationRecord
  self.table_name = :arrivals
  include Virtus.model(mass_assignment: false, constructor: false)
  include CustomAttributes
  include HasAttachments
  include HasDetails
  include Restricted
  include Reopener
  include StateManager

  belongs_to :company
  belongs_to :expedient_file, class_name: 'Expedient', foreign_key: :file_id, optional: true
  belongs_to :store
  belongs_to :user
  belongs_to :entity

  attribute :current_user, User
  has_many    :responsables, through: :file
  has_many    :all_details, class_name: "ExpedientArrivalDetail", foreign_key: :arrival_id, inverse_of: :arrival
  # accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true

  include ArrivalValidator

  before_validation :set_stock
  validates_associated :details, :childs
  
  include TrazabilidadValidator::SinProductosRepetidos
  include TrazabilidadValidator::CantidadesMenorIgual
  include TrazabilidadValidator::BatchesSonDelProducto

  def set_stock
    transaction do
      if need_stock_rollback?
        remove_stock
      elsif approved? && state_changed? && !new_record?
        add_stock
      end
    end
  end

  def name_with_parent
    "R.: #{number}"
  end

  def need_stock_rollback?
    changes[:state] == ["Finalizado", "Pendiente"] ||
    changes[:state] == ["Finalizado", "Anulado"]   ||
    changes[:state] == ["Aprobado", "Pendiente"]   ||
    changes[:state] == ["Aprobado", "Anulado"]
  end

  def add_stock
    details.each do |detail|
      detail.entity_id = self.entity_id
      detail.add_stock
      detail.childs.each{ |d| d.add_stock}
    end
  end

  def remove_stock
    details.each do |detail|
      detail.entity_id = self.entity_id
      detail.need_to_remove_stock = true
      detail.childs.each do |child|
        child.need_to_remove_stock = true
        child.entity_id = self.entity_id
      end
    end
    # details.each {|detail| detail.need_to_remove_stock = true && entity_id = self.entity_id}
    # details..each  {|child| child.need_to_remove_stock = true && entity_id = self.entity_id}
  end

  def self.search(number)
    if !number.blank?
      where("#{table_name}.number ILIKE ?", "%#{number}%")
    else
      all
    end
  end


  #def assign(documents, number)
    #Anmat::Arrival.new(arrival: self, documents: documents, n_remito: number).assign
  #end

  def confirm
    anmat = Anmat::Traceability.new()
    details.each do |detail|
      anmat.confirmar_transaccion(detail.transaction) unless detail.transaction.blank?
    end
  end

  def pdf_name
    "remito_#{number}"
  end

end

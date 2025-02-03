class ExpedientDevolution < ApplicationRecord
	self.table_name = :devolutions
	attr_accessor :devolution_type
	include StateManager
	include Virtus.model(mass_assignment: false, constructor: false)
  include CustomAttributes
  include HasAttachments
  include HasDetails
  include Restricted
  include Numerable
  include Reopener

  belongs_to :company
  belongs_to :entity
  belongs_to :file,class_name: "Expedient"
	belongs_to :user
  belongs_to :store
	has_many    :responsables, through: :file
  before_validation :set_user

  before_validation :remove_stock, :add_stock
  validates_associated :details

  attribute :current_user, User
  
  include TrazabilidadValidator::CantidadesCoinciden
  include TrazabilidadValidator::SinProductosRepetidos
  include TrazabilidadValidator::BatchesSonDelProducto
  include TrazabilidadValidator::CrearBatchPorDefecto
  
  def set_user
    self.user_id ||= current_user.id
  end

	def self.search(number)
    if !number.blank?
      where("#{table_name}.number ILIKE ?", "%#{number}%")
    else
      all
    end
  end

  def remove_stock
    transaction do
      if confirmed? && state_changed?
        forze_to_remove_stock
      end
    end
  end

  def forze_to_remove_stock
    details.each do |detail|
      detail.need_to_remove_stock = true
    end
  end

  def add_stock
    transaction do
      if need_stock_rollback?
        forze_to_add_stock
      end
    end
  end

  def forze_to_add_stock
    details.each do |detail|
      detail.add_stock
      detail.childs.each{ |d| d.add_stock}
    end
  end

  def need_stock_rollback?
    changes[:state] == ["Finalizado", "Pendiente"] ||
    changes[:state] == ["Finalizado", "Anulado"]   ||
    changes[:state] == ["Confirmado", "Pendiente"] ||
    changes[:state] == ["Confirmado", "Anulado"]   ||
    changes[:state] == ["Aprobado", "Pendiente"]   ||
    changes[:state] == ["Aprobado", "Anulado"]
  end

	def pdf_name
    "devolución_#{number}"
	end

end

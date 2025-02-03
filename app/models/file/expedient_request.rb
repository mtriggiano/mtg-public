# frozen_string_literal: true

class ExpedientRequest < ApplicationRecord
  self.table_name = :requests
  include Virtus.model(mass_assignment: false, constructor: false)
  include CustomAttributes
  include HasAttachments
  include HasDetails
  include Restricted
  include Numerable
  include Reopener
  include StateManager

  TYPES = ['Bajo stock', 'Pedido de venta', 'Pedido de cirugía'].freeze

  # include BelongsToFile
  include RequestValidator

  store_accessor :custom_attributes, :pacient
  store_accessor :custom_attributes, :doctor
  store_accessor :custom_attributes, :place
  store_accessor :custom_attributes, :delivery_date
  store_accessor :custom_attributes, :insurance
  store_accessor :custom_attributes, :shipping

  belongs_to :file, class_name: 'Expedient'
  belongs_to :company
  belongs_to :entity, optional: true
  belongs_to :client, foreign_key: :entity_id, optional: true
  belongs_to :supplier, foreign_key: :entity_id, optional: true
  belongs_to :seller, class_name: 'User', optional: true
  belongs_to :user

  has_many   :budgets,   through: :file
  has_many   :orders,    through: :file
  has_many   :bills,     through: :file
  has_many   :shipments, through: :file
  has_many   :responsables, through: :file
  has_many   :all_details, class_name: "ExpedientRequestDetail", foreign_key: :request_id
  scope      :pendings, ->{where(state: 'Pendiente')}

  attribute :current_user, User

  def name_with_parent
		Expedient.unscoped do
	    case type.deconstantize
	    when "Surgeries"
	      "Exp.Cx: #{file.number} - Solic.: #{number}"
	    when "Purchases"
	      "Exp.Comp: #{file.number} - Solic.: #{number}"
	    end
		end
  end

  def init_date
    read_attribute(:init_date) || file.try(:init_date) || Date.today
  end

  def final_date
    read_attribute(:final_date) || file.try(:finish_date) || Date.today
  end

  def details_without_stock
    details.reject(&:has_available_stock?)
  end

  def details_without_enough_stock
    details.reject(&:has_enough_stock?)
  end

  def pacient
    file.pacient unless file.nil?
  end

  def pdf_name
    "solicitud_#{number}"
  end
end

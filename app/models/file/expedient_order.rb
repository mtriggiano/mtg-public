class ExpedientOrder < ApplicationRecord
	self.table_name = :orders
	include StateManager
  #include OrderValidator
  include Virtus.model(mass_assignment: false, constructor: false)
  include CustomAttributes
  include HasAttachments
  include HasDetails
  include Restricted
  #include Numerable
  include Reopener
	include PdfCurrency

  belongs_to  :company
  belongs_to  :expedient, class_name: "Expedient", optional: true, foreign_key: :file_id
  belongs_to  :user
	belongs_to  :entity
	belongs_to  :store, optional: true
  attribute   :current_user, User
  has_many    :custom_details, class_name: "ExpedientOrderCustomDetail", dependent: :destroy, foreign_key: :order_id
  has_many    :responsables, through: :expedient
	has_many 		:order_payment_days, as: :payable
  has_many    :payment_orders, class_name: "Purchases::PaymentOrder", foreign_key: :order_id
  has_many    :payment_order_details, through: :payment_orders, source: :details
	has_many		:payment_types, through: :order_payment_days
  has_many    :all_details, class_name: "ExpedientOrderDetail", foreign_key: :order_id
  has_many    :sellers, through: :all_details
	has_many 	 	:expedient_bill_orders, foreign_key: :order_id, inverse_of: :expedient_order
	has_many 		:expedient_bills, through: :expedient_bill_orders
  after_save  :set_total_left, :set_custom_details

  store_accessor :custom_attributes, :note

	scope :billed, ->{joins(:expedient_bills).where(bills: {state: "Confirmado"}).group(:id).having("SUM(bills.total) >= orders.total")}

  accepts_nested_attributes_for :custom_details, reject_if: :all_blank, allow_destroy: true
	accepts_nested_attributes_for :order_payment_days, reject_if: :all_blank, allow_destroy: true

  TYPES  = ["Cirugía", "Venta regular", "Licitación", "Venta por mostrador"]


	def self.search(number)
    if !number.blank?
      where("#{table_name}.number ILIKE ?", "%#{number}%")
    else
      all
    end
  end

  def name_with_parent
		Expedient.unscoped do
	    case type.deconstantize
	    when "Surgeries"
	      "Exp.Cx: #{expedient.number} - O.C.: #{number}"
	    when "Purchases"
	      "Exp.Comp: #{expedient.number} - O.C.: #{number}"
	    end
		end
  end

  def department
    "Ventas"
  end

  def set_total_left
    update_column(:total_left, total.round(2) - payment_order_details.sum(:total).round(2))
  end

  def set_custom_details
    if custom_details.blank? && approved?
      DetailPdf.new(self, with_childs: true).build.each do |d|
        cd =  custom_details.build(d.compact.except('type', 'id', 'iva', 'iva_amount', 'bonus_amount', 'own', 'supplier'))
        cd.custom_detail = true
        cd.save
      end
    end
  end

  def custom_details_builder
    return custom_details unless custom_details.blank?
    details.each do |detail|
      custom_details.build(
          quantity: detail.quantity,
          product_name: detail.product_name,
          price: detail.price,
          total: detail.total
      )
    end
    return custom_details
  end

	def expected_delivery_date
	  read_attribute(:init_date) || Date.today
	end

	def total_iva
		details.map{|detail| detail.iva_amount }.inject(0,:+)
	end

	def name
		": OC-#{number}"
	end
end

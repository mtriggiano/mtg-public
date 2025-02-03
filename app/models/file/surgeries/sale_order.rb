class Surgeries::SaleOrder < ExpedientOrder
  include Notificable
  include Numerable
  belongs_to :file, class_name: "Surgeries::File", foreign_key: :file_id, inverse_of: :sale_orders, optional: true
  belongs_to :client, foreign_key: :entity_id

  inherit_details_from :budget
  share_numeration_with %w(Surgeries::SaleOrder Sales::Order Tenders::Order)

  has_many :sale_orders_budgets, foreign_key: :order_id, inverse_of: :sale_order
  has_many :budgets, through: :sale_orders_budgets
  has_many :shipment_sale_orders, foreign_key: :order_id
  has_many :shipments, through: :shipment_sale_orders
  

  accepts_nested_attributes_for :file, allow_destroy: false
  accepts_nested_attributes_for :sale_orders_budgets, reject_if: :all_blank, allow_destroy: true

  def self.search search
    return all if search.blank?
    where("orders.number ILIKE (?)", "#{search}%")
  end

  def details_without_enough_stock
    details.select{ |detail| not detail.has_enough_stock? }
  end

  def has_pdf?
    true
  end

  def pdf_name
    "orden_de_venta_#{number}"
  end

  def name
    "Cirugía: NV-#{number}"
  end

  def to_s
		"O.V. Nº #{number}"
	end
end

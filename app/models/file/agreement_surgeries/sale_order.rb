class AgreementSurgeries::SaleOrder < ExpedientOrder
  #include Notificable
  include Numerable
  belongs_to :file, class_name: "AgreementSurgeries::File", foreign_key: :file_id, inverse_of: :sale_orders, optional: true
  belongs_to :client, foreign_key: :entity_id

  share_numeration_with %w(Surgeries::SaleOrder Sales::Order Tenders::Order Surgeries::SaleOrder)
  accepts_nested_attributes_for :file, allow_destroy: false


  inherit_details_from :budget
  has_many :sale_orders_budgets, class_name: "AgreementSurgeries::SaleOrdersBudget", foreign_key: :order_id, inverse_of: :sale_order
  has_many :budgets, through: :sale_orders_budgets

  
  accepts_nested_attributes_for :file, allow_destroy: false
  accepts_nested_attributes_for :sale_orders_budgets, reject_if: :all_blank, allow_destroy: true

  def has_pdf?
  	true
  end

  def pdf_name
    "orden_de_venta_#{number}"
  end
end
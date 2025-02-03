class Purchases::Budget < ExpedientBudget
  belongs_to :file, class_name: 'Purchases::File', foreign_key: :file_id
  belongs_to :supplier, class_name: "Supplier", foreign_key: :entity_id
  belongs_to :supplier_contact, optional: true, class_name: 'SupplierContact', foreign_key: :entity_contact_id

  has_many   :budgets_purchase_requests, class_name: 'Purchases::BudgetRequest',dependent: :destroy, inverse_of: :budget

  has_many   :purchase_request, class_name: "Purchases::PurchaseRequest", through: :budgets_purchase_requests, source: :purchase_request
  has_many   :order_budgets, class_name: "Purchases::OrdersBudget", dependent: :destroy, inverse_of: :budget
  has_many   :orders, through: :file
  has_many   :arrivals, through: :file
  has_many   :returns, through: :file
  has_many   :bills, through: :file
  has_many   :devolutions, through: :file

  inherit_details_from :purchase_request

  accepts_nested_attributes_for :budgets_purchase_requests, allow_destroy: true, reject_if: :all_blank
  before_validation :at_least_one_request
  validates_presence_of :budgets_purchase_requests, message: 'Debe asignar al menos una solicitud de compra'

  after_save :create_price_history, if: :approved?

  def at_least_one_request
    budgets_purchase_requests.build if budgets_purchase_requests.reject(&:marked_for_destruction?).size == 0
  end

  def self.search number
    if not number.blank?
      where("#{table_name}.number ILIKE ?", "%#{number}%")
    else
      all
    end
  end

  def check_request_details
      purchase_request.joins(:details).each do |request|
          request.details.group_by{|d| d.product_id}.each do |product_id, detalles|
              requested_quantity = 0
              detalles.each{|detalle| requested_quantity += detalle.quantity}
              budgeted_quantity = self.details.where(product_id: product_id).sum(:quantity)
              detalles.each{|d| d.update_column(:budgeted, true)} unless budgeted_quantity < requested_quantity
          end
      end
  end

  def set_client_activity
    activity = Activity.new(activitable: supplier, user: current_user, company_id: company_id)
    ActivityRecord.new(activity: activity, parent: {link: "/purchases/budgets/#{id}/edit", number: number}).for_new_budget(state)
  end

  def create_price_history
      records = []
      details.each do |detail|
          records << detail.inventary.purchase_price_histories.build(price: detail.price, entity_id: entity_id, currency: "ARS") unless detail.price == 0
      end
      PurchasePriceHistory.import(records)
  end

  def has_pdf?
    false
  end


end

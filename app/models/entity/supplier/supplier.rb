class Supplier < Entity
  has_many   :expense_details, foreign_key: :entity_id, dependent: :destroy
  has_many 	 :contacts, class_name: "SupplierContact", dependent: :destroy, foreign_key: "entity_id"
  has_many   :records, through: :contacts
  has_many   :account_movements, class_name: 'SupplierAccountMovement', foreign_key: "entity_id"
  has_many   :purchase_orders, class_name: "Purchases::Order", foreign_key: :entity_id
  has_many   :purchase_returns, class_name: "Purchases::Devolution", foreign_key: :entity_id
  has_many   :purchase_budgets, class_name: "Purchases::Budget", foreign_key: :entity_id
  has_many   :purchase_invoices, class_name: "Purchases::Bill", foreign_key: :entity_id
  has_many   :purchase_arrivals, class_name: "Purchases::Arrival", foreign_key: :entity_id
  has_many   :purchase_requests, class_name: "Purchases::PurchaseRequest", foreign_key: :entity_id
  has_many :supplier_products, foreign_key: :entity_id
  has_many :products, through: :supplier_products
  has_many :related_products, class_name: 'Product', foreign_key: 'supplier_id', inverse_of: :supplier


  IVA_COND = Company::IVA_COND

  validates_length_of :bank, maximum: 150, message: "Nombre de entidad bancaria demasiado largo"
  validates_uniqueness_of :cbu, scope: [:company_id, :active], message: "El C.B.U. de la entidad bancaria ya existe.", allow_blank: true
  validates_length_of :cbu, is: 22, message: "El C.B.U. debe contener 22 dígitos", allow_blank: true
  validates_numericality_of :cbu, message: "El C.B.U. solo puede contener caracteres numéricos", allow_blank: true
  validates_presence_of :sector, message: "Debe indicar si el proveedor pertenece al sector público o privado"

  def self.search search
    return all if search.blank?
    where("LOWER(entities.name) ILIKE LOWER(?)", "%#{search}%")
  end

  def to_s
    "#{self.name}"
  end

  def set_saved_user_activity
    super do |record|
      previous_changes[:id].nil? ? record.for_new_supplier : record.for_saved_supplier
    end
  end

  def current_month_operations
    account_movements.where("EXTRACT(month from account_movements.created_at) = ? AND EXTRACT(year from account_movements.created_at) = ?", Date.today.month, Date.today.year).count
  end

  def total_billed
    purchase_invoices.approveds.sum(:total)
  end

  def department
    "Proveedores"
  end
end

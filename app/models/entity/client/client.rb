class Client < Entity
  belongs_to :payment_type, optional: true
  belongs_to :province, optional: true
  belongs_to :locality, optional: true
  belongs_to :parent, class_name: "Client", optional: true
  has_many :childs, class_name: "Client", foreign_key: :parent_id
  has_many :contacts, class_name: "ClientContact", foreign_key: :entity_id
	has_many :account_movements, class_name: 'ClientAccountMovement', foreign_key: :entity_id
	has_many :bills, class_name: "ExpedientBill", foreign_key: :entity_id
  has_many :budgets, class_name: "ExpedientBudget", foreign_key: :entity_id
  has_many :shipments, class_name: "ExpedientShipment", foreign_key: :entity_id
  has_many :payment_types
  has_many :bank_check_payments, foreign_key: :entity_id
  has_many :expedient_receipts, foreign_key: :entity_id


  before_save :set_locality

  TYPES=[["A.R.T.", "art"], ["Consumidor final", "final_consumer"], ["Obra social", "insurance"], ["Adm. pública", "public_administration"], ["Hospital", "hospital"], ["Privado", "private"]]

	def set_saved_user_activity
    super do |record|
      previous_changes[:id].nil? ? record.for_new_client : record.for_saved_client
    end
	end

  def department
    "Clientes"
  end

  def set_locality
    # code
  end

  def self.search q
    return all if q.blank?
    where("name LIKE :search OR denomination LIKE :search OR document_number LIKE :search", search: "%#{q}%")
  end
end

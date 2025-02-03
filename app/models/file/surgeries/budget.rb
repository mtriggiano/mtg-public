class Surgeries::Budget < ExpedientBudget
    include Notificable
    belongs_to :file, class_name: "Surgeries::File", foreign_key: "file_id"

    belongs_to :client, foreign_key: :entity_id, optional: true
    belongs_to :client_contact, foreign_key: :entity_contact_id, optional: true
    has_many   :budgets_prescriptions, class_name: "Surgeries::BudgetPrescription", inverse_of: :budget, foreign_key: :budget_id
    has_many   :prescriptions, through: :budgets_prescriptions
    has_many   :requests, 	through: :file
    has_many   :orders, 	through: :file
    has_many   :bills, 		through: :file
    has_many   :shipments, 	through: :file
    has_many   :responsables, through: :file

    before_validation :at_least_one_prescription
    after_save :create_price_history, if: :approved?

    inherit_details_from :prescription

    accepts_nested_attributes_for :budgets_prescriptions, reject_if: :all_blank, allow_destroy: true

    def self.search number
        if not number.blank?
            where("#{table_name}.number ILIKE ?", "%#{number}%")
        else
            all
        end
    end

    def at_least_one_prescription
        budgets_prescriptions.build if budgets_prescriptions.reject(&:marked_for_destruction?).size == 0
    end

    def department
      "Ventas"
    end

    def create_price_history
        # records = []
        # details.each do |detail|
        #     records << detail.inventary.sale_price_histories.build(price: detail.price, entity_id: entity_id)
        # end
        # SalePriceHistory.import(records)
    end

    def has_pdf?
      true
    end

    def to_s
  		"Presupuesto Nº #{number}"
  	end
end

class Surgeries::BudgetPrescription < ApplicationRecord

    self.table_name = :budgets_requests
    belongs_to :budget, class_name: "Surgeries::Budget", foreign_key: :budget_id, inverse_of: :budgets_prescriptions
    belongs_to :prescription, class_name: "Surgeries::Prescription", foreign_key: :request_id, optional: true

    before_validation :set_type
    validates_presence_of :prescription, message: "Debe asociar una receta o solicitud"

    def set_type
        self.type = "Surgeries::BudgetPrescription"
    end
end
class AgreementSurgeries::Budget < ExpedientBudget
  belongs_to :file, class_name: "AgreementSurgeries::File", foreign_key: "file_id"
  belongs_to :client, foreign_key: :entity_id, optional: true
  belongs_to :client_contact, foreign_key: :entity_contact_id, optional: true

  def has_pdf?
    true
  end

  def to_s
    "Presupuesto Nº #{number}"
  end
end
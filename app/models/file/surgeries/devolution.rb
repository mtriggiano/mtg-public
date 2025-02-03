class Surgeries::Devolution < ExpedientDevolution
  belongs_to :file, class_name: 'Surgeries::File', foreign_key: :file_id
  belongs_to :supplier, class_name: "Supplier", foreign_key: :entity_id
  has_many   :devolutions_shipments, class_name: 'Surgeries::DevolutionShipment',dependent: :destroy, inverse_of: :devolution, foreign_key: :devolution_id
  has_many   :shipments, class_name: "Surgeries::Shipment", through: :devolutions_shipments, source: :shipment
  has_many   :devolutions_consumptions, class_name: 'Surgeries::DevolutionConsumption', dependent: :destroy, inverse_of: :devolution, foreign_key: :devolution_id
  has_many   :consumptions, class_name: "Surgeries::Consumption", through: :devolutions_consumptions, source: :consumption
  has_many   :devolutions_external_arrivals, class_name: "Surgeries::DevolutionArrival", dependent: :destroy, inverse_of: :devolution, foreign_key: :devolution_id
  has_many   :external_arrivals, class_name: "ExternalArrival", through: :devolutions_external_arrivals, source: :external_arrival
  has_many   :requests, 	through: :file
  has_many   :orders, 	through: :file
  has_many   :bills, 		through: :file
  has_many   :responsables, through: :file

  inherit_details_from :shipment
  rest_details_from :consumption
  secondary_assign_details_from :external_arrivals

  accepts_nested_attributes_for :devolutions_shipments, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :devolutions_external_arrivals, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :devolutions_consumptions, allow_destroy: true, reject_if: :all_blank

  def has_pdf?
    true
  end

  def to_s
		"Devolución Nº #{number}"
	end

  def for_secondary_assign(documents, number)
    if documents
      ids = documents.map(&hash_accessor('id'))
      documents = company.external_arrivals.where(id: ids)
      assign(documents, number)
    end
  end

end

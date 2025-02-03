class Tenders::SaleRequest < ExpedientRequest
  include Notificable
  belongs_to  :file, class_name: "Tenders::File"

  has_many :all_details, class_name: "Surgeies::SaleRequestDetail", foreign_key: :request_id

  def self.search search
    return all if search.blank?
    where("requests.number ILIKE (?)", "#{search}%")
  end

  def department
    "Compras"
  end

  def to_s
		"Pliego Nº #{number}"
	end

  def has_pdf?
    false
  end

end

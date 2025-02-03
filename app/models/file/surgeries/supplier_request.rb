class Surgeries::SupplierRequest < ExpedientRequest
	#include Notificable
  	belongs_to  :file, class_name: "Surgeries::File"
  	belongs_to  :supplier, foreign_key: :entity_id
  	has_many    :supplier_requests_purchase_requests,
                dependent: :destroy,
                class_name: "Surgeries::PurchaseRequestSupplierRequest",
                foreign_key: :supplier_request_id,
                inverse_of: :supplier_request
  	has_many    :purchase_requests, through: :supplier_requests_purchase_requests, class_name: "Surgeries::PurchaseRequest"
    has_many    :details, class_name: "Surgeries::SupplierRequestDetail", foreign_key: :request_id, dependent: :destroy

    before_validation :set_total
  	inherit_details_from :purchase_request

  	accepts_nested_attributes_for :supplier_requests_purchase_requests, reject_if: :all_blank, allow_destroy: true

    store_accessor :custom_attributes, :total

  	def self.search search
    	return all if search.blank?
    	where("requests.number ILIKE (?)", "#{search}%")
  	end

  	def department
    	"Compras"
  	end

    def to_s
  		"Pedido Nº #{number}"
  	end

  	def has_pdf?
  		true
  	end

    def set_total
      self.total = details.reject(&:marked_for_destruction?).map(&:supplier_price).sum
    end

    def subtotal
      details.sum("coalesce(cast(nullif(custom_attributes -> 'supplier_price','') as float),0)").to_f
    end

    def total
      read_attribute(:total) || subtotal
    end
end

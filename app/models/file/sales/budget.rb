class Sales::Budget < ExpedientBudget
  	include Notificable
  	belongs_to :client, foreign_key: :entity_id
  	belongs_to :client_contact, foreign_key: :entity_contact_id, optional: true
   	belongs_to :file, class_name: "Sales::File", foreign_key: "file_id"

    has_many   :budgets_sale_requests, class_name: "Sales::BudgetSaleRequest", inverse_of: :budget, foreign_key: :budget_id
    has_many   :sale_requests, through: :budgets_sale_requests
    has_many   :requests, 	through: :file
    has_many   :orders, 	through: :file
    has_many   :bills, 		through: :file
    has_many   :shipments, 	through: :file
    has_many   :responsables, through: :file

    after_save :touch_file, if: :approved?
    after_save :create_price_history, if: :approved?

    inherit_details_from :sale_request

    accepts_nested_attributes_for :budgets_sale_requests, reject_if: :all_blank, allow_destroy: true

    validates_presence_of :budgets_sale_requests, message: 'Debe asociar al menos una solicitud de venta'
    before_validation :at_least_one_request

    def at_least_one_request
        budgets_sale_requests.build if budgets_sale_requests.reject(&:marked_for_destruction?).size == 0
    end

    def self.search number
        if not number.blank?
            where("#{table_name}.number ILIKE ?", "%#{number}%")
        else
            all
        end
    end

    def touch_file
		  file.touch
	  end

    def department
      "Ventas"
    end

    def create_price_history
        records = []
        details.each do |detail|
            unless detail.product_id.nil?
                records << detail.inventary.sale_price_histories.build(price: detail.price, entity_id: entity_id, currency: "ARS") unless detail.price == 0
            end
        end
        SalePriceHistory.import(records)
    end

    def has_pdf?
      true
    end
end

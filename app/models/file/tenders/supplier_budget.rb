class Tenders::SupplierBudget < ExpedientBudget
  	include Notificable
  	belongs_to :client, foreign_key: :entity_id
  	belongs_to :client_contact, foreign_key: :entity_contact_id, optional: true
   	belongs_to :file, class_name: "Tenders::File", foreign_key: "file_id"

    has_many   :supplier_budgets_sale_requests, class_name: "Tenders::BudgetSaleRequest", inverse_of: :supplier_budget, foreign_key: :budget_id
    has_many   :sale_requests, through: :supplier_budgets_sale_requests


    has_many   :orders, 	through: :file
    has_many   :bills, 		through: :file
    has_many   :shipments, 	through: :file
    has_many   :responsables, through: :file
    has_many   :supplier_requests, through: :file

    inherit_details_from :sale_request

    accepts_nested_attributes_for :supplier_budgets_sale_requests, reject_if: :all_blank, allow_destroy: true

    # validates_presence_of :supplier_budgets_sale_requests, message: 'Debe asociar al menos una solicitud de venta'
    # before_validation :at_least_one_request

    store_accessor :custom_attributes,
      :supplier_name

    after_save :touch_file, if: :approved?

    #after_save :create_price_history, if: :approved?

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
            records << detail.inventary.sale_price_histories.build(price: detail.price, entity_id: entity_id, currency: "ARS") unless detail.price == 0
        end
        SalePriceHistory.import(records)
    end

    def has_pdf?
      true
    end
end

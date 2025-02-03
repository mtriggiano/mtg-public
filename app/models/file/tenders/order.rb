class Tenders::Order < ExpedientOrder
	include Notificable
	include Numerable
	belongs_to :file, class_name: "Tenders::File", foreign_key: "file_id"
	belongs_to :client, foreign_key: :entity_id

	has_many :orders_budgets, 			class_name: "Tenders::OrderBudget",foreign_key: :order_id, inverse_of: :order
	has_many :order_purchase_requests, 	class_name: "Purchases::TenderOrderPurchaseRequest", foreign_key: :order_id, inverse_of: :tender_order
	has_many :purchase_requests, 		class_name: "Purchases::PurchaseRequest", through: :order_purchase_requests, source: :purchase_request
	has_many :budgets, 					through: :orders_budgets

	has_many :shipment_orders
	has_many :shipments, through: :shipment_orders

	inherit_details_from :budget
	accepts_nested_attributes_for :orders_budgets, reject_if: :all_blank, allow_destroy: true
	after_save :create_purchase_request, if: :approved?
	after_save :merge_with_budget

	validates_presence_of :orders_budgets, message: 'Debe asociar al menos un presupuesto'

	def self.search search
		return all if search.blank?
		where("orders.number ILIKE (?)", "#{search}%")
	end

	def details_without_enough_stock
		details.select{ |detail| not detail.has_enough_stock? }
	end

	def create_purchase_request
		if details_without_enough_stock.any?
			p_file = create_purchase_file(file.title)
		  	request = p_file.purchase_requests.build(
				user_id: user_id,
				company_id: company_id,
				init_date: Date.today,
	    		final_date: file.finish_date,
				request_type: "Pedido de cirugía",
				observation: observation,
				state: "Pendiente",
				generated_by_system: true,
				external_file_id: file_id
		  	)
			request.purchase_requests_tender_orders.build(order_id: id, type: 'Purchases::TenderOrderPurchaseRequest')
			request.assign_details_from_order(self)
			request.current_user = current_user
			request.set_number
			request.save(validate: false)
		end
	end

	def create_purchase_file(title=nil)
		file = Purchases::File.new(
			company_id: company_id,
			user_id: current_user.id,
			title: "S.A. - #{title}",
			init_date: Date.today,
			state: "En espera de solicitud",
			description: "Generado automaticamente por el sistam debido a la falta de stock para la orden de venta Nº #{number}",
			initial_department: Department.find_by_name("Compras").id
		)
		file.set_number
		file.generated_by_system = true
		file.save
		return file
	end

	def merge_with_budget
		details.each{ |detail| detail.merge_with_budget }
	end

	def has_pdf?
	  true
	end

	def pdf_name
    "orden_de_venta_#{number}"
  end

	def name
	  "Licitación: NV-#{number}"
	end
end

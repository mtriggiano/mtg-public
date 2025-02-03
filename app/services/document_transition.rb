class DocumentTransition
# 	include Virtus.model
#
# 	attribute :from, String
# 	attribute :to, String
# 	attribute :in_charge, User
#
# 	attribute :sale_request, SaleRequest
# 	attribute :sale_budget, SaleBudget
# 	attribute :sale_order, SaleOrder
# 	attribute :sale_bill, SaleBill
#
# 	attribute :surgery_sale_order, SurgerySaleOrder
#
# 	attribute :purchase_request, PurchaseRequest
# 	attribute :purchase_budget, PurchaseBudget
# 	attribute :purchase_order, PurchaseOrder
# 	attribute :purchase_invoice, PurchaseInvoice
#
# 	def make_transition
# 		eval("from_#{from}_to_#{to}")
# 	end
#
# 	#SALE TRANSITIONS
# 		def from_sale_request_to_sale_budget
# 			company = sale_request.company
# 			client  = sale_request.client
# 			sale_file = sale_request.sale_file
#
# 			budget = SaleBudget.new(
# 				user_id: in_charge.id,
# 				company_id: company.id,
# 				entity_id: client.id,
# 				sale_file_id: sale_file.id
# 			)
#
# 			sale_request.details.each do |detail|
# 				budget.details.new(
# 					detail_type: detail.detail_type,
# 					product_id: detail.product_id,
# 					product_name: detail.product_name,
# 					product_code: detail.product.code,
# 					product_measurement: detail.product_measurement,
# 					quantity: detail.approved_quantity,
# 					price: detail.product.price,
# 					total: detail.quantity * detail.product.price
# 				)
# 			end
#
# 			budget.sale_budget_requests.new(sale_request_id: sale_request.id)
#
# 			budget.set_number
# 			budget.save(validate: false)
# 		end
#
# 		def from_sale_budget_to_sale_order
# 			company 	= sale_budget.company
# 			client  	= sale_budget.client
# 			sale_file 	= sale_budget.sale_file
#
# 			order = SaleOrder.new(
# 				user_id: in_charge.id,
# 				company_id: company.id,
# 				entity_id: client.id,
# 				sale_file_id: sale_file.id
# 			)
#
# 			sale_budget.details.each do |detail|
# 				order.details.new(
# 					detail_type: detail.detail_type,
# 					product_id: detail.product_id,
# 					product_name: detail.product_name,
# 					product_code: detail.product.code,
# 					quantity: detail.quantity,
# 					price: detail.product.price,
# 					total: detail.quantity * detail.product.price
# 				)
# 			end
#
# 			order.sale_request_orders.new(sale_request_id: sale_request.id)
#
# 			order.set_number
# 			order.save(validate: false)
# 		end
#
# 		def from_sale_order_to_sale_bill
# 			company 	= sale_order.company
# 			client  	= sale_order.client
# 			sale_file 	= sale_order.sale_file
#
# 			bill = SaleBill.new(
# 				user_id: in_charge.id,
# 				company_id: company.id,
# 				entity_id: client.id,
# 				sale_file_id: sale_file.id,
# 				sale_point: company.sale_points.first.number
# 			)
#
# 			bill.set_default_cbte_tipo
# 			bill.set_concept
# 			bill.set_iva_cond
#
# 			sale_order.details.each do |detail|
# 				bill.details.new(
# 					product_id: detail.product_id,
# 					product_name: detail.product_name,
# 					product_code: detail.product.code,
# 					product_measurement: detail.product.measurement,
# 					quantity: detail.quantity,
# 					iva_aliquot: "0.21",
# 					price_per_unit: detail.product.price,
# 					subtotal: detail.quantity * detail.product.price
# 				)
# 			end
#
# 			bill.sale_order_bills.new(sale_order_id: sale_order.id)
#
# 			bill.save(validate: false)
# 		end
# 	# SALE TRANSITIONS
#
# 	# PURCHASE TRANSITIONS
# 		def from_purchase_request_to_purchase_budget
# 			company 		= purchase_request.company
# 			purchase_file 	= purchase_request.purchase_file
#
# 			budget = PurchaseBudget.new(
# 				user_id: in_charge.id,
# 				company_id: company.id,
# 				purchase_file_id: purchase_file.id
# 			)
#
# 			budget.details.reset
#
# 			purchase_request.details.each do |detail|
# 				budget.details.new(
# 					product_name: detail.product_name,
# 					product_id: detail.product_id,
# 					product_supplier_code: detail.product.supplier_code,
# 					quantity: detail.quantity,
# 					price: detail.product.price,
# 					total: detail.quantity * detail.product.price
# 				)
# 			end
# 			budget.purchase_budget_requests.new(purchase_request_id: purchase_request.id)
#
# 			budget.set_number
# 			budget.save(validate: false)
# 		end
#
# 		def from_purchase_budget_to_purchase_order
# 			company 		= purchase_budget.company
# 			purchase_file 	= purchase_budget.purchase_file
#
# 			order = PurchaseOrder.new(
# 				user_id: in_charge.id,
# 				company_id: company.id,
# 				purchase_file_id: purchase_file.id,
# 				supplier_id: purchase_budget.supplier_id
# 			)
#
# 			order.details.reset
#
# 			purchase_budget.details.each do |detail|
# 				order.details.new(
# 					product_name: detail.product_name,
# 					product_id: detail.product_id,
# 					product_supplier_code: detail.product_supplier_code,
# 					quantity: detail.quantity,
# 					discount: detail.discount,
# 					price: detail.product.price,
# 					total: detail.quantity * detail.product.price
# 				)
# 			end
# 			order.purchase_order_budgets.new(purchase_budget_id: purchase_budget.id)
#
# 			order.set_number
# 			order.save(validate: false)
# 		end
#
# 		def from_purchase_order_to_purchase_invoice
# 			company 		= purchase_order.company
# 			supplier 		= purchase_order.supplier
# 			purchase_file 	= purchase_order.purchase_file
#
# 			invoice = PurchaseInvoice.new(
# 				user_id: in_charge.id,
# 				company_id: company.id,
# 				purchase_file_id: purchase_file.id,
# 				supplier_id: purchase_order.supplier_id,
# 				cbte_tipo: AfipBill.new(supplier: supplier, company: company).purchase_invoice_cbte_tipos.first
# 			)
#
# 			invoice.details.reset
#
# 			purchase_order.details.each do |detail|
# 				invoice.details.new(
# 					product_name: detail.product_name,
# 					product_id: detail.product_id,
# 					product_supplier_code: detail.product_supplier_code,
# 					quantity: detail.quantity,
# 					discount: detail.discount,
# 					gross_price: detail.product.price,
# 					total: detail.quantity * detail.product.price
# 				)
# 			end
#
# 			invoice.save(validate: false)
# 		end
#
# 		def from_purchase_order_to_purchase_arrival
# 			company 		= purchase_order.company
# 			supplier 		= purchase_order.supplier
# 			purchase_file 	= purchase_order.purchase_file
#
# 			arrival = PurchaseArrival.new(
# 				user_id: in_charge.id,
# 				company_id: company.id,
# 				purchase_file_id: purchase_file.id,
# 				supplier_id: purchase_order.supplier_id,
# 				store_id: company.stores.first.try(:id)
# 			)
#
# 			arrival.details.reset
#
# 			purchase_order.details.each do |detail|
# 				arrival.details.new(
# 					product_name: detail.product_name,
# 					product_id: detail.product_id,
# 					product_supplier_code: detail.product_supplier_code,
# 					requested_quantity: detail.quantity
# 				)
# 			end
#
# 			arrival.purchase_arrival_orders.new(purchase_order_id: purchase_order.id)
# 			arrival.set_number
#
# 			arrival.save(validate: false)
# 		end
#
# 		def from_sale_order_to_purchase_request
# 			company = sale_order.company
#
# 			request = PurchaseRequest.new(
# 				user_id: in_charge.id,
# 				current_user: in_charge,
# 				company_id: company.id,
# 				date: Date.today,
# 				generated_by_system: true
# 			)
#
# 			request.details.reset
#
# 			sale_order.details_without_stock.each do |detail|
# 				request.details.new(
# 					product_name: detail.product_name,
# 					product_id: detail.product_id,
# 					product_measurement: detail.product_measurement,
# 					quantity: detail.stock_needed,
# 					detail_type: detail.detail_type,
# 					description: detail.description
# 				)
# 			end
# 			request.purchase_request_sale_orders.new(sale_order_id: sale_order.id)
#
# 			request.set_number
# 			request.check_purchase_file
# 			request.save(validate: false)
# 		end
# 	# PURCHASE TRANSITIONS
#
# 	#SURGERY TRANSITIONS
# 		def from_surgery_sale_order_to_surgery_request
# 			request = SurgeryRequest.build_from_surgery_sale_order(surgery_sale_order)
# 			request.set_number
# 			pp request.save(validate: false)
# 			pp request.errors
# 		end
# 	#SURGERY TRANSITIONS
end

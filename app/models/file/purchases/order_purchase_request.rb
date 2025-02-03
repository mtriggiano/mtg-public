class Purchases::OrderPurchaseRequest < ExpedientOrderRequest
	belongs_to :order, 		class_name: "Purchases::Order", 				foreign_key: :order_id, 	inverse_of: :order_purchase_requests
	belongs_to :purchase_request, 	class_name: "Purchases::PurchaseRequest", 	foreign_key: :request_id, 	inverse_of: :purchase_requests_sale_orders
end
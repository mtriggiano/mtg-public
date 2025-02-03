# module ExpedientBinnacle
#   extend ActiveSupport::Concern
#
# 	included do
#
#     after_save :create_expedient_binnacle, if: :need_to?
#
#     def need_to?
#       if self.class.column_names.include?("state")
#         (saved_change_to_state? || saved_change_to_id?) && (!reopened? || !pending?)
#       else
#         false
#       end
#     end
#
#     def create_expedient_binnacle
#       document = self
#       file = document.try(:file)
#       unless file.nil?
#         binnacle = file.expedient_binnacles.where(document_id: document.try(:id), document_type: document.try(:type), date: Time.now, user_id: document.current_user.id).first_or_initialize
#         description = ""
#         case document
#         if document.saved_change_to_id?
#           description = "Se creo un nuevo documento #{get_object_name(document.class.to_s)} con el número #{document.try(:number)}"
#         elsif document.canceled?
#           description = "Se anuló o canceló el documento #{get_object_name(document.class.to_s)} con el número #{document.try(:number)}"
#         else
#           description = "Se actualizó el documento #{get_object_name(document.class.to_s)} con el número #{document.try(:number)} al estado #{document.try(:state)}"
#         end
#         binnacle.description = description
#         binnacle.save
#       end
#     end
#
#     def get_object_name klass
#       case when
#       when "ExternalBill"
#         "Factura de compra"
#       when "ExternalArrival"
#         "Remito de entrada"
#       when "Purchases::Budget"
#         "Presupuesto de compra"
#       when "Purchases::Devolution"
#         "Devolución"
#       when "Purchases::Order"
#         "Orden de compra"
#       when "Purchases::PaymentOrder"
#         "Orden de pago"
#       when "Purchases::PurchaseRequest"
#         "Solicitud de compra"
#       when "Sales::Bill"
#         "Factura de venta"
#       when "Sales::Budget"
#         "Presupuesto de venta"
#       when "Sales::Order"
#         "Orden de venta"
#       when "Sales::Receipt"
#         "Recibo de venta"
#       when "ExpedientReceipt"
#         "Recibo de venta"
#       when "Sales::Shipment"
#         "Remito de salida"
#       when "Surgeries::Budget"
#         "Cotización"
#       when "Surgeries::ClientBill"
#         "Factura de venta"
#       when "Surgeries::Consumption"
#         "Consumo"
#       when "Surgeries::Prescription"
#         "Receta"
#       when "Surgeries::PurchaseOrder"
#         "Orden de compra"
#       when "Surgeries::PurchaseRequest"
#         "Solicitud de compra"
#       when "Surgeries::Receipt"
#         "Recibo"
#       when "Surgeries::SaleOrder"
#         "Orden de venta"
#       when "Surgeries::Shipment"
#         "Remito de salida"
#       when "Surgeries::SupplierBill"
#         "Factura de compra"
#       when "Tenders::Budget"
#         "Presupuesto"
#       when "Tenders::Bill"
#         "Factura"
#       when "Tenders::Order"
#         "Orden de venta"
#       when "Tenders::Shipment"
#         "Remito de salida"
#       else
#         "N/A"
#       end
#     end
#   end
# end

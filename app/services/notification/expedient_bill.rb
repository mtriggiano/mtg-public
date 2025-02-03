class Notification::ExpedientBill < NotificationMaker
	attr_accessor :bill, :notifications

	def initialize(bill)
  	@notifications = []
  	@bill = bill
	end

  def send_unmerged_stock
    title = "Factura registrada que difiere del remito."
    body  = "La factura N° #{bill.number} difiere de lo especificado en el remito asociado. Por favor revise."
    notifications << build(title, body, bill, bill.user_id)
    send_notification(notifications)
  end
end

class Tenders::ShipmentMailer < ApplicationMailer

  def send_to sale_shipment, email
    @sale_shipment = sale_shipment

   	attachment = render_to_string(
   		template: 'sales/shipments/show.pdf.haml',
   		locals: {:@sale_shipment => @sale_shipment},
   		layout: 'pdf.html',
   		zoom: 3.1,
   		viewport_size: '1280x1024',
	    page_size: 'A4',
	    encoding:"UTF-8")
   	@pdf = WickedPdf.new.pdf_from_string( attachment )

   	attachments['Remito.pdf'] = @pdf

	mail to: email, subject: "Remito Nº #{sale_shipment.number} - #{sale_shipment.company.name}"
  end
end

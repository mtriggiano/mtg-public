class Purchases::OrderMailer < ApplicationMailer

  def send_to order, email
    @order = order
    attachment = render_to_string(
   		template: 'purchases/orders/show.pdf.haml',
   		locals: {:@order => @order},
   		layout: 'pdf.html',
   		zoom: 3.1,
   		viewport_size: '1280x1024',
	    page_size: 'A4',
	    encoding:"UTF-8")
   	@pdf = WickedPdf.new.pdf_from_string( attachment )

   	attachments['OrdenDeCompra.pdf'] = @pdf
	  mail to: email, subject: "Orden de compra Nº #{order.number} - #{order.company.name}"
  end
end

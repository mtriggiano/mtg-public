class Reports::SellIvaMovementMailer < ApplicationMailer

	def send_to bills
    	@bills = bills
    	attachment = render_to_string(
	   		template: '/reports/sell_iva_movements/export.xlsx.axlsx',
	   		locals: {:@bills => @bills},
	   		layout: 'reporte.html',
	   		zoom: 3.1,
	   		viewport_size: '1280x1024',
		    page_size: 'A4',
		    encoding:"UTF-8")
   		@pdf = WickedPdf.new.pdf_from_string( attachment )

   		attachments['Presupuesto.pdf'] = @pdf
	  	mail to: email, subject: "Presupuesto Nº #{sale_budget.number} - #{sale_budget.company.name}"
  	end
end
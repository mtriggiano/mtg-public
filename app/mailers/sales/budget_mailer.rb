class Sales::BudgetMailer < ApplicationMailer

  def send_to sale_budget, email
    @budget = sale_budget
    attachment = render_to_string(
   		template: 'sales/budgets/show.pdf.haml',
   		locals: {:@sale_budget => @budget},
   		layout: 'pdf.html',
   		zoom: 3.1,
   		viewport_size: '1280x1024',
	    page_size: 'A4',
	    encoding:"UTF-8")
   	@pdf = WickedPdf.new.pdf_from_string( attachment )

   	attachments['Presupuesto.pdf'] = @pdf
	  mail to: email, subject: "Presupuesto Nº #{sale_budget.number} - #{sale_budget.company.name}"
  end
end

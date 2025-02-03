module ShowPdf
	extend ActiveSupport::Concern

	included do
		alias_method :object_pdf, "#{controller_name.snakecase.singularize}".to_sym
	end

	def show
  		respond_to do |format|
	      format.html
	      format.pdf do
	        render pdf: "documento-n-#{object_pdf.number}",
	        layout: 'pdf.html',
	        template: "#{controller_path}/show",
	        zoom: 3.1,
	        viewport_size: '844x1500',
	        page_size: 'A4',
	        encoding:"UTF-8"
	      end
	    end
  	end
end
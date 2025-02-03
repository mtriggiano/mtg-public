module BasicCrud
	extend ActiveSupport::Concern
	included do
		before_action :set_current_user
	end

	def show
		require 'barby'
  	require 'barby/barcode/code_25_interleaved'
  	require 'barby/outputter/png_outputter'

		respond_to do |format|
			format.html
			format.pdf{
				if record.respond_to?(:imprimible?)
					if record.imprimible?
						render pdf: "#{record.pdf_name}",
						layout: 'pdf.html',
						viewport_size: '1280x1024',
						page_size: 'A4',
						disposition: 'inline',
						encoding:"UTF-8"
					else
						redirect_to [:edit, record], notice: "Solo se pueden imprimir documentos autorizados/confirmados"
					end
				else
					render pdf: "#{record.pdf_name}",
					layout: 'pdf.html',
					viewport_size: '1280x1024',
					page_size: 'A4',
					disposition: 'inline',
					encoding:"UTF-8"
				end
				}
		end
	end

	def new
		assign_details if record.respond_to?(:assign_details)
	end

  def edit
		assign_details if record.respond_to?(:assign_details)
  end

	def create
		if record.save
			unless record.try(:file).nil?
				record.file.update_columns(state: params[:file_state], substate: params[:file_substate]) if params[:file_state] && params[:file_substate]
			end
			redirect_to [:edit, record], notice: t('.success')
		else
			pp record.errors if Rails.env == "development"
			render :new
		end
	end

	def update
		if record.update(eval("#{record.class.name.demodulize.snakecase}_params"))
			unless record.try(:file).nil?
				record.file.update_columns(state: params[:file_state], substate: params[:file_substate]) if params[:file_state] && params[:file_substate]
			end
			redirect_to [:edit, record], notice: t('.success')
		else
			pp record.errors if Rails.env == "development"
			render :edit
		end
	end

	def destroy
		if record.destroy
			redirect_to request.referer, notice: t('.success')
		else
			pp record.errors if Rails.env == "development"
			redirect_to polymorphic_path([record.class.name.pluralize.snakecase.gsub("/","_")]), alert: 'No se puede eliminar'
		end
	end

	private
		def record
			eval(controller_name.singularize)
		end

		def set_current_user
			record.current_user = current_user
		end
end

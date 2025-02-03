module SupplierFilter
	extend ActiveSupport::Concern

	included do
		alias_method :object, "#{controller_name.snakecase.pluralize}".to_sym
	end

	def index_by_supplier
		result =   object
		.approveds
		.where(entity_id: params[:secondary_data])
		.search(params[:q])
		.order(:number)
		.map{|sr| {id: sr.id, text: sr.number, total_left: sr.total_left}}
		render json: result
	end
end

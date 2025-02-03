module ClientFilter
	extend ActiveSupport::Concern

	included do
		alias_method :object, "#{controller_name.snakecase.pluralize}".to_sym
	end

	def index_by_client
		render json: object.approveds.where(entity_id: params[:secondary_data]).where("#{object.table_name}.number ILIKE ?", "%#{params[:q]}%").order(:number).map{|sr| {id: sr.id, text: sr.number, total_left: sr.total_left}}
	end

end

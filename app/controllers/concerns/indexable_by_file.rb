module IndexableByFile
	extend ActiveSupport::Concern

	included do
		alias_method :collection, "#{controller_name.snakecase.pluralize}".to_sym
	end

	def index_by_file
		if params[:extra_data]
			if self.class.name.deconstantize == "Purchases"
				render json: collection.where(purchase_file_id: params[:extra_data]).where("LOWER(#{collection.table_name}.number) ILIKE LOWER(?)", "%#{params[:q]}%").map{ |pr| {id: pr.id, text: pr.number} }
			elsif self.class.name.deconstantize == "Sales"
				render json: collection.where(sale_file_id: params[:extra_data]).where("LOWER(#{collection.table_name}.number) ILIKE LOWER(?)", "%#{params[:q]}%").map{ |pr| {id: pr.id, text: pr.number} }
			else
				render json: collection.approveds.where(surgery_file_id: params[:extra_data]).where("LOWER(#{collection.table_name}.number) ILIKE LOWER(?)", "%#{params[:q]}%").map{ |pr| {id: pr.id, text: pr.number} }
			end
		else
			render json: collection.where("LOWER(#{collection.table_name}.number) ILIKE LOWER(?)", "%#{params[:q]}%").map{ |pr| {id: pr.id, text: pr.number} }
		end
	end
end
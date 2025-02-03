module Indexable

	extend ActiveSupport::Concern

	included do
		helper_method :collection
		skip_load_and_authorize_resource only: :index
	end

	def index
		if request.format.json?
			if params[:for_select]
				if collection.respond_to?(:approveds)
					render json: collection.approveds.map(&:attributes)
				else
					render json: collection.map(&:attributes)
				end
			else
				authorize! :read, obj unless finance_controller?
				render json: "#{controller_path.classify}Datatable".constantize.new(params, view_context: view_context, collection: collection), status: 200
			end
		else
			authorize! :read, obj unless finance_controller?
		end
	end


	private

		def finance_controller?
			controller_path.split("/").first == "finances"
		end

		def collection
			eval(controller_name)
		end

		def obj
			eval(controller_name.singularize)
		end

		def skip_authorization?
			request.format.json? && params[:for_select]
		end

	    def self.custom(opts={})
	     	@parent_key =  opts[:keys].first || :company
	     	@parent_value = eval("#{opts[:keys].map{|h| h.to_s}.join(".")}.find(params[#{opts[:value]}])")
	     	return self
	    end
end

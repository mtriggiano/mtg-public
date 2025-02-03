class ApplicationDatatable < AjaxDatatablesRails::ActiveRecord
	extend Forwardable

	def initialize(params, opts = {})
  		@view 			= opts[:view_context]
  		@collection   ||= opts[:collection]
  		super
	end

	def view_columns
		@view_columns = Hash.new
		eval("DatatableConstants::#{@collection.model.name}").map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def data
	  	records.map do |record|
	  		presenter = "#{@collection.model.name}Presenter".constantize.new(record, @view)
	  		result = Hash.new
	    	eval("DatatableConstants::#{@collection.model.name}").keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

	def get_raw_records
		@collection
	end
end

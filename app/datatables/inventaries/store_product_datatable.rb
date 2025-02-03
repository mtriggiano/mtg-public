class Inventaries::StoreProductDatatable < AjaxDatatablesRails::ActiveRecord

  extend Forwardable

	def initialize(params, opts = {})
  		@view 			= opts[:view_context]
  		@collection   ||= opts[:collection]
  		super
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::StoreProduct.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def data
	  	records.map do |record|
	  		presenter = Inventaries::StoreProductPresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::StoreProduct.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

  def get_raw_records
    Store
      .joins(articles: :product)
      .select("stores.*, products.id as product_id, products.name as product_name, products.code as product_code, products.available_stock as product_available_stock, products.minimum_stock as product_minimum_stock, products.gtin as product_gtin, products.selectable as product_selectable, products.branch as product_branch, stocks.available as quantity")
      .where("stores.id = ? AND stocks.available > 0", @collection.id)
  end
end

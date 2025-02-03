class Inventaries::ProductCategoriesController < ApplicationController

	expose :product_categories, ->{current_company.product_categories}
	expose :product_category, scope: ->{current_company.product_categories}

	include Indexable
	include BasicCrud

	def create
	  if product_category.save
			redirect_to product_categories_path
		end
	end

	def update
		if product_category.update(product_category_params)
			redirect_to product_categories_path
		end
	end

	private
		def product_category_params
			params.require(:product_category).permit(:name, :default_iva, supplier_categories_attributes: [:id, :supplier_id, :_destroy])
		end
end

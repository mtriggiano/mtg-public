class Inventaries::BoxesController < ApplicationController
	before_action :set_s3_direct_post, only: [:new, :edit, :create, :update]
	before_action :set_permission, only: :index
	expose :boxes, ->{ current_company.boxes.includes(box_products: [product: :images]) }
	expose :box, scope: ->{ boxes }
	expose :products, -> {current_company.products.includes(:images).search(params[:search], params[:exclude], params[:own]).paginate(page: params[:page])}
	expose :box_products, -> {box.products.paginate(page: params[:page], per_page:10)}
	include Indexable
	include BasicCrud
	skip_load_and_authorize_resource only: [:index_by_company, :search]

	def index_by_company
		#authorize! :read, Product
		render json: boxes.where("LOWER(products.name) ILIKE LOWER(?)", "%#{params[:term]}%").map{|sc| {
			id: sc.id,
			text: sc.name,
			product_code: sc.code,
			product_price: sc.price,
			product_measurement: sc.medida,
			product_price_history: sc.historical_purchase_prices.last(5).map(&:price),
			childs: sc.child_products.map{|child| {id: child.id, text: child.name, product_code: child.code, product_price: child.price, product_measurement: child.medida}}}}
	end

	def search

	end

	private

		def box_params
			params.require(:box).permit(:selectable, :name, :code, :own, :measurement_unit, :product_category_id, :traceable,
				images_attributes: [:id, :source, :_destroy],
				box_products_attributes: [:id, :quantity, :product_id, :_destroy])
		end

		def set_permission
			authorize! :read, Box
		end
end

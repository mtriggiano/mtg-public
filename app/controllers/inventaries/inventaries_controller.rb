class Inventaries::InventariesController < ApplicationController
	skip_load_and_authorize_resource
	expose :inventaries, ->{current_company.inventaries}
	expose :inventary, scope: ->{inventaries}

	skip_load_and_authorize_resource only: [:sale_price_history, :purchase_price_history, :stock]

	def sale_price_history
		product = current_company.inventaries.includes(sale_price_histories: :client).find(params[:id])
		budgets = product.sale_price_histories.where(entity_id: params[:entity_id], currency: "ARS").last(1).map{|h| { client: h.client.name, price: h.price, date: h.created_at.strftime("%d/%m/%Y"), currency: h.currency} }
		budgets.push(product.sale_price_histories.last(1).map{|h| { client: h.client.try(:name), price: h.price, date: h.created_at.strftime("%d/%m/%Y"), currency: h.currency} }.first)
		render json: budgets.compact
	end

	def purchase_price_history
		inventaries = current_company.inventaries.includes(purchase_price_histories: :supplier).find(params[:id])
		render json: inventaries.purchase_price_histories.where(entity_id: params[:entity_id], currency: "ARS").last(5).map{|h| { client: h.supplier.name, price: h.price, date: h.created_at.strftime("%d/%m/%Y"), currency: h.currency} }
	end

	def stock
		render json: inventary.available_stock
	end
end

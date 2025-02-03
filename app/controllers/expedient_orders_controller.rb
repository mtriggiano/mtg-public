class ExpedientOrdersController < ApplicationController
	include Fileable
	include Indexable
	include BasicCrud
	skip_before_action :set_current_user

	def index
		render json: current_company.expedient_orders
			.joins(:entity, :expedient).where(entities: {type: "Supplier"}).where(files: {open: true}).where.not(files: {state: 'Finalizado'})
			.approveds
			.search(params[:q])
			.order(updated_at: :desc)
			.map{|o| {text: o.name_with_parent, id: o.id}}
	end
end

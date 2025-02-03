class ExpedientRequestsController < ApplicationController
	include Fileable
	include Indexable
	include BasicCrud
	skip_before_action :set_current_user

	def index
		render json: current_company.expedient_requests
			.where(type: ["Purchases::PurchaseRequest", "Surgeries::PurchaseRequest"])
			.search(params[:q])
			.order(updated_at: :desc)
			.approveds.map{|o| {text: o.name_with_parent, id: o.id}}
	end
end

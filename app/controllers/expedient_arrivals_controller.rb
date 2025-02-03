class ExpedientArrivalsController < ApplicationController
	include Fileable
	include Indexable
	include BasicCrud
	skip_before_action :set_current_user

	def index
		render json: current_company.expedient_arrivals
			.approveds.order(updated_at: :desc)
			.search(params[:q])
			.map{|o| {text: o.name_with_parent, id: o.id}}
	end
end

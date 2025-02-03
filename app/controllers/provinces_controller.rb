class ProvincesController < ApplicationController
  skip_load_and_authorize_resource

  def consultar_localidades
		render json: Locality.where(province_id: params[:province_id]).order(:name).map{|l| {id: l.id, text: l.name}}
	end

end

class Finances::CheckbooksController < ApplicationController
	skip_load_and_authorize_resource
	expose :checkbook
	before_action :set_current_user, only: [:create, :update]

	def create
		if checkbook.save
			redirect_to checkbook, notice: "Chequera creada con éxito."
		else
			render :new
		end
	end

	def update
		if checkbook.update(checkbook_params)
			redirect_to checkbook, notice: "Chequera actualizada con éxito."
		else
			render :edit
		end
	end

	def destroy
		if checkbook.destroy
			redirect_to checkbooks, notice: "Chequera eliminada con éxito"
		else
			render :index
		end
	end


	private

	def checkbook_params
		params.require(:checkbook).permit(:number, :init_number, :bank_account_id, :final_number, :serie)
	end

	def set_current_user
    checkbook.extend(Virtus.model)
    checkbook.attribute :user, User
    checkbook.user = current_user
	end
end

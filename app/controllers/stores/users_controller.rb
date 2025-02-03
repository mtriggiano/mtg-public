class Stores::UsersController < ApplicationController
	  expose :store, scope: ->{ current_company.stores}, id: ->{ params[:store_id] || params[:user].try(:[],:store_id) }
  	expose :users, 	  ->{ store.users }
  	expose :user, scope: -> {store.users }

  	def index
  		respond_to do |format|
  			format.html
  			format.js
  			format.json { render json: StoreUserDatatable.new(params, view_context: view_context, store: store), status: 200 }
  		end
  	end

  	def new_invitation
  	end

  	def invite
      user.set_medic_role
  		respond_to do |format|
	    	if user.invite!(current_user)
	    		format.html { redirect_to stores_external_path(user.store_id, view: 'users'), notice: "Invitación enviada. Le llegará un mail a #{user.email} con instrucciones." }
	    	else
	    		format.html { render :index }
	    	end
	    end
	  end

	private

	def user_params
	 	params.require(:user).permit(:email, :first_name, :last_name, :store_id)
	end

end

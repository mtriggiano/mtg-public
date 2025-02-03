class Stores::Externals::StoreActivitiesController < ApplicationController
	expose :external_store, scope: ->{ current_company.external_stores}, id: ->{ params[:external_id] }
  	expose :store_activity, scope: ->{ external_store.activities }
  	expose :store_activities, ->{ external_store.activities}
  	skip_load_and_authorize_resource

  	def index
  		respond_to do |format|
  			format.html
  			format.js
  			format.json { render json: StoreActivityDatatable.new(params, view_context: view_context, external_store: external_store), status: 200 }
  		end
  	end

end
class Stores::StocksController < ApplicationController

  	expose :store, scope: ->{ current_company.stores}
  	expose :stocks, ->{ store.stocks }
  	skip_load_and_authorize_resource

  	def index
      authorize! :read, Product
  		respond_to do |format|
  			format.html
  			format.js
  			format.json { render json: StockDatatable.new(params, view_context: view_context, store: store), status: 200 }
  		end
  	end
end

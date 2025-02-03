class Entities::Clients::ClientAccountMovementsController < ApplicationController

  expose :client, scope: -> { current_company.clients }
  expose :client_account_movements, ->{ client.account_movements.order("account_movements.id DESC")}
  expose :client_account_movement, scope: ->{ client_account_movements }
  alias_method :object, :client_account_movements
  include Indexable

  def show; end

  def new; end

  def edit; end

  private



  def account_movement_params
  	params.require(:account_movement).permit()
  end

end

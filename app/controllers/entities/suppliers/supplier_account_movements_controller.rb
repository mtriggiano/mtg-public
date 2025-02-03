class Entities::Suppliers::SupplierAccountMovementsController < ApplicationController

  expose :supplier, scope: -> { current_company.suppliers }
  expose :supplier_account_movements, ->{ supplier.account_movements.order("account_movements.id DESC")}
  expose :supplier_account_movement, scope: ->{ supplier_account_movements }

  include Indexable

  def show; end

  def new; end

  def edit; end

  private

  def account_movement_params
  	params.require(:account_movement).permit()
  end

end

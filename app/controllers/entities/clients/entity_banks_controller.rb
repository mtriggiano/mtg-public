class Entities::Clients::EntityBanksController < ApplicationController

  expose :client, scope: -> { current_company.clients }
  expose :entity_banks, ->{ client.entity_banks}
  expose :entity_bank, scope: ->{ entity_banks }

  alias_method :object, :entity_banks
  include Indexable

  def show; end

  def new;end

  def create
    client = current_company.clients.find(params[:entity_bank][:entity_id])
    respond_to do |format|
      if client.entity_banks.create(entity_bank_params)
        format.html { redirect_to client_path(client, view: "banks"), notice: "Creado exitosamente"}
      else
        render :new
      end
    end
  end

  def update
    client = current_company.clients.find(params[:entity_bank][:entity_id])
    respond_to do |format|
      if client.entity_banks.find(params[:id]).update(entity_bank_params)
        format.html { redirect_to client_path(client, view: "banks"), notice: "Actualizado exitosamente"}
      else
        render :edit
      end
    end
  end

  def destroy
    respond_to do |format|
      if current_company.clients.find(entity_bank.entity_id)
        entity_bank.destroy
        format.html { redirect_to client_path(client, view: "banks"), notice: "Eliminado exitosamente"}
      end
    end
  end

  def edit; end

  private

  def entity_bank_params
  	params.require(:entity_bank).permit(:name, :cbu, :alias, :cuit, :account_type, :branch_office, :denomination)
  end

end

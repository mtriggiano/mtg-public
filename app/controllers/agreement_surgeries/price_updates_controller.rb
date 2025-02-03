class AgreementSurgeries::PriceUpdatesController < ApplicationController
  expose :price_updates, ->{ current_company.price_updates }
  expose :price_update, scope: -> {price_updates}, model: "AgreementSurgeries::PriceUpdate"

  before_action :set_price_update, only: [:show, :edit, :update, :destroy]

  include Indexable
  include BasicCrud


  # GET /price_updates
  # GET /price_updates.json
  def index2
    @price_updates = AgreementSurgeries::PriceUpdate.all
  end

  # GET /price_updates/1
  # GET /price_updates/1.json
  def show
  end

  # GET /price_updates/new
  def new2
    @price_update = AgreementSurgeries::PriceUpdate.new
  end

  # GET /price_updates/1/edit
  def edit
  end

  # POST /price_updates
  # POST /price_updates.json
  def create
    authorize! :create, price_update
    price_update.current_user = current_user
    price_update.created_by = current_user
    respond_to do |format|
      if price_update.save
        ok, error = price_update.actualizar
        price_update.log = ok ? "Precios actualizados correctamente" : error 
        price_update.save
        format.html { redirect_to price_update, notice: "Actualizacion de Precio creada con exito" }
      else
        pp price_update.errors
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /price_updates/1
  # PATCH/PUT /price_updates/1.json
  def update
    respond_to do |format|
      if @price_update.update(price_update_params)
        format.html { redirect_to @price_update, notice: 'Price update was successfully updated.' }
        format.json { render :show, status: :ok, location: @price_update }
      else
        format.html { render :edit }
        format.json { render json: @price_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /price_updates/1
  # DELETE /price_updates/1.json
  def destroy
    @price_update.destroy
    respond_to do |format|
      format.html { redirect_to price_updates_url, notice: 'Price update was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price_update
      @price_update = AgreementSurgeries::PriceUpdate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def price_update_params
      params.require(:agreement_surgeries_price_update).permit(:percent, :company)
    end
end

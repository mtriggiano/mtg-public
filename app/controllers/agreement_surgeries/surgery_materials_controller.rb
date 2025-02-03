class AgreementSurgeries::SurgeryMaterialsController < ApplicationController
  expose :surgery_materials, ->{current_company.surgery_materials}
  expose :surgery_material, scope: -> { surgery_materials }, model: "AgreementSurgeries::SurgeryMaterial"

  include Indexable
  include BasicCrud

  def create
    authorize! :create, surgery_material
    surgery_material.current_user = current_user
    surgery_material.user = current_user
    respond_to do |format|
      if surgery_material.save
        format.html { redirect_to surgery_material, notice: "Material creado con exito" }
      else
        pp surgery_material.errors
        format.html { render :new }
      end
    end
  end

  def update
    authorize! :update, surgery_material
    surgery_material.current_user = current_user
    surgery_material.updated_by = current_user
    respond_to do |format|
      if surgery_material.update(surgery_material_params)
        format.html { redirect_to surgery_material, notice: "Material actualizada con éxito" }
      else
        format.html { render :edit }
      end
    end
  end

  def index_by_company
    surgery_materials = current_company.surgery_materials.limit(20)
    surgery_materials = surgery_materials.search(params[:q]) if params[:q].present?
    surgery_materials = surgery_materials.or(surgery_materials.where(id: params[:current_surgery_naterial])) if params[:current_surgery_naterial].present?
    surgery_materials = surgery_materials.map do |surgery_material| 
      { 
        id: surgery_material.id, 
        text: surgery_material.description,
        surgery_material_description: surgery_material.description,
        surgery_material_id: surgery_material.id,
        product_price: surgery_material.price
      }
    end 
    render json: surgery_materials
  end

  def edit_update_prices
  end
  
  def update_prices
    percent = update_prices_params[:percent].to_f.round(2) rescue nil
    ok, error = AgreementSurgeries::SurgeryMaterial.update_prices(percent)
    if ok
      redirect_to agreement_surgeries_surgery_materials_path, notice: "Precios actualizados correctamente." 
    else
      redirect_back(fallback_location: root_path, alert: "Ha ocurido un error: #{error}") 
    end
  end


  private
  def surgery_material_params
  	 params.require(:agreement_surgeries_surgery_material).permit(
      :code,
  	 	:description,
		  :category,
		  :origin,
		  :price,
      :minimum_price,
      :maximum_price, 
		  :active,
  	 )
  end

  def update_prices_params
    params.require(:agreement_surgeries_surgery_material).permit(
      :percent
    )
  end

end

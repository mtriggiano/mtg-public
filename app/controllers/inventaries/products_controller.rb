class Inventaries::ProductsController < ApplicationController
  expose :products, ->{ current_company.products.includes([:product_category]) } #VER ANTES DE BORRAR
  expose :product, scope: ->{ products }
  
  include Indexable
  include BasicCrud
  include Attachable
  before_action :set_current_user, except: :import
  skip_load_and_authorize_resource only: [:index_by_company, :filter_by_supplier, :filter_by_product, :filter_by_delivered_product]
  skip_before_action :verify_authenticity_token, only: :import
  
  def create
    if product.save
      redirect_to product
    else
      render :new
    end
  end
  
  def update
    if product.update(product_params)
      redirect_to product
    else
      render :edit
    end
  end
  
  def index_by_company
    recharge = current_company.clients.find(params[:extra_data]).try(:recharge) unless params[:extra_data].blank?
    prods = current_company.inventaries
    result = prods.where("((LOWER(products.name) ILIKE LOWER(:search) OR LOWER(products.code) ILIKE LOWER(:search)) AND products.active = 't' AND products.selectable = 't') OR (products.id = :current_product)", search: "%#{params[:q]}%", current_product: params[:current_product]).last(10).map{|sc| {
    id: sc.id,
    text: sc.name,
    product_code: sc.code,
    product_branch: sc.branch,
    product_supplier_code: params[:extra_data].blank? ? nil : sc.supplier_code(params[:extra_data]),
    product_measurement: sc.medida,
    product_price_history: nil,
    recharge: recharge,
    traceable: sc.traceable,
    childs_size: sc.dig(:products, :size)
    #childs: sc.product_type == "regular" ? [] : sc.products.map{|child| {id: child.id, text: child.name, product_code: child.code, product_price: child.price, product_measurement: child.medida}}
    }}.last(10)
  
    render json: result
  end
  
  def filter_by_supplier
    supplier_product = current_company.supplier_products.find_by(product_id: params[:explicit_data], entity_id: params[:extra_data])
    if supplier_product
      render json: supplier_product.batches.where(state: true).map{|b| {text: b.full_text, id: b.id}}
    else
      render json: [{text: "Producto no trazable o proveedor no seleccionado", id: nil}]
    end
  end
  
  def filter_by_product
    batches = current_company.batches.where(state: true, product_id: params[:explicit_data])
    if batches
      render json: batches.map{|b| {text: b.full_text, id: b.id}}
    else
      render json: [{text: "Producto no trazable o proveedor no seleccionado", id: nil}]
    end
  end
  
  def filter_by_delivered_product
    batches = current_company.batches.joins(:batch_details).where(product_id: params[:explicit_data], batch_details: {detail_type: "ExpedientShipmentDetail"})
    render json: batches.map{|b| {text: b.full_text, id: b.id}}
  end
  
  def import
    if params[:anmat]
      Stock::Importer.import_anmat(current_user, params[:store_id])
    else
      Stock::Importer.new(file: params[:file], company: current_user.company).import
    end
      respond_to do |format|
      format.html { redirect_to products_path, notice: 'Los productos están siendo cargados. Le avisaremos cuando termine el proceso.' }
    end
  end
  
  def export
    respond_to do |format|
      format.xlsx {
    	render xlsx: "export.xlsx.axlsx", disposition: "attachment", filename: "Lista-productos.xlsx"
      }
    end
  end
  
  def import_format
    #Se utiliza el parametro empty en true cuando se quiere descargar el formato del excel solamente.
    respond_to do |format|
      format.xlsx {
        render xlsx: "format.xlsx.axlsx", disposition: "attachment", filename: "Lista-productos.xlsx"
      }
    end
  end
  
  def fix_stock
    if product.fix_stock
      redirect_to request.referer, notice: "Stock corregido en base a la cantidad indicada en todos los lotes disponibles"
    else
      redirect_to request.referer, alert: "No se puede actualizar el stock"
    end
  end

  def new_clean_stock

  end

  # resetea en 0 todas las unidades de Stock disponible, Lotes y Depostisos
  def clean_stock
    if params[:password].present? && current_user.valid_password?(params[:password])
      if product.clean_stock
        redirect_to product_path(product, view: 'location'), notice: "Stock fue reiniciado correctamente"
      else
        redirect_to request.referer, alert: "No se puede actualizar el stock"
      end
    else
      redirect_to request.referer, alert: "Error al verificar el password"
    end
  end
  
  # Listado de stock valorizado
  def valores_stock
	  @products = current_company.products.preload(:supplier, :product_category, batches: :batch_stores, purchases_order_details: :order, sales_bill_details: :expedient_bill)
	  filtered
    
    if request.format.json?
	  render json: Inventaries::ProductValorStockDatatable.new(
	  	params, 
	  	view_context: view_context, 
	  	collection: @products
	  ), status: 200
	  end
  end

  def valores_stock_totales
    @products = current_company.products.preload(:supplier, :product_category, batches: :batch_stores, purchases_order_details: :order, sales_bill_details: :expedient_bill)
	  filtered
    totales = totalizar
    render json: totales
  end
  
  private 

  def totalizar 
    totalizador = {
      stock: 0,
      total_productos: 0,
      valor_total: 0,
      valor_total_usd: 0
    }
    if params[:filtros].present? && params[:filtros][:store_id].present?
      totalizador[:stock] = @products
        .joins(:batch_stores)
        .where("batch_stores.store_id = #{params[:filtros][:store_id]}")
        .pluck("batch_stores.quantity")
        .sum.to_i
    else
      totalizador[:stock] = @products.pluck(:available_stock).sum.to_i
    end
    totalizador[:total_productos] = @products.count
    @products.each do |product|
      presenter = Inventaries::ProductValorStockPresenter.new(product, view_context)
      total = presenter._get_stock * presenter._buy_price
      totalizador[:valor_total] += total ? total : 0
      total = presenter._get_stock * presenter._buy_price_usd
      totalizador[:valor_total_usd] += total ? total.to_f : 0
    end
    totalizador
  end

  def filtered
    return unless params[:filtros].present?
	if filtro_params[:product_id].present?
      @products = @products.where(id: filtro_params[:product_id])
    end

	if filtro_params[:branch].present?
	  @products = @products.where("LOWER(products.branch) ilike ?", "%#{filtro_params[:branch].to_s.downcase}%")
	end

	if filtro_params[:product_category_id].present?
	  @products = @products.where(product_category_id: filtro_params[:product_category_id])
	end

	if filtro_params[:supplier_id].present?
	  @products = @products.where(supplier_id: filtro_params[:supplier_id])
	end

	if filtro_params[:family].present?
	  @products = @products.where("LOWER(products.family) ilike ?", "%#{filtro_params[:family].to_s.downcase}%")
	end

  if filtro_params[:branches].present?
    branches = filtro_params[:branches].compact.delete_if{|estado| estado.empty? }
    @products = @products.where("LOWER(products.branch) IN (?)", branches.map(&:downcase)) if branches.present?
  end

  if filtro_params[:store_id].present?
    @products = @products.by_store(filtro_params[:store_id])
  end

	case filtro_params[:activos]
    when "Activos"
      @products = @products.where(type: "Surgeries::Shipment")
    when "No activos"
      @products = @products.where(type: "Sales::Shipment")
    end if filtro_params[:activos].present?

	if filtro_params[:codigo].present?
	  @products = @products.where("LOWER(products.code) ilike ?", "%#{filtro_params[:codigo].to_s.downcase}%")
	end
  end

  private

  def product_params
    params.require(:product).permit(
      :selectable, 
      :photo, 
      :name, 
      :own, 
      :branch, 
      :source, 
      :code, 
      :family, 
      :measurement_unit, 
      :product_category_id, 
      :gtin, 
      :pm, 
      :minimum_stock, 
      :recommended_stock,
      :supplier_id,
      :buy_price,
      images_attributes: [
        :id, 
        :source, 
        :_destroy
      ]
    )
  end

  def filtro_params
	params.require(:filtros).permit(
	  :product_id,
	  :activos,
	  :codigo,
	  :branch,
	  :product_category_id,
	  :family,
	  :supplier_id,
    :store_id, 
    branches: []
	)
  end

end

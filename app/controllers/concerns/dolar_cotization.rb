module DolarCotization
  extend ActiveSupport::Concern

  def dolar_cotization
    if params[:date]
      billete = Dolar::Bna::Exchange.new(params[:date].to_date).perform_bna_billete
    else
      billete = Dolar::Bna::Exchange.new(Date.today).perform_bna_billete
    end
    if billete.nil?
      @dolar_billete_buy = 0
      @dolar_billete_sell = 0
      @dolar_variation = 0
    else
      @dolar_billete_buy = billete[:compra]
      @dolar_billete_sell = billete[:venta]
      @dolar_variation = Dolar::Bna::Exchange.new(Date.today).variation_billete
    end
    respond_to do |format|
      format.html
      format.js
      format.json { render json: {dolar_sell: @dolar_billete_sell, dolar_buy: @dolar_billete_buy, dolar_variation: @dolar_variation} }
    end
  end

  def conversion
    if params[:price]
      aliquot = params[:aliquot].blank? ? 0 : params[:aliquot].to_f
      date = params[:date].blank? ? Date.today : params[:date].to_date
      dolar = Dolar::Bna::Convert.new(params[:price], params[:conversion], "Billete", date, aliquot).perform
    else
      dolar = 0
    end
    render json: {dolar: dolar}
  end

end

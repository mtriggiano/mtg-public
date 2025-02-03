class TodayDolarGetter

  def initialize

  end

  def call
    get_day_dolar
  end


  private

  def get_day_dolar
    billete = Dolar::Bna::Exchange.new(Date.today).perform_bna_billete
    if billete.nil?
      dolar_billete_buy = 0
      dolar_billete_sell = 0
      #dolar_variation = 0
    else
      dolar_billete_buy = billete[:compra]
      dolar_billete_sell = billete[:venta]
      #dolar_variation = Dolar::Bna::Exchange.new(Date.today).variation_billete
    end
    #return dolar_billete_buy, dolar_billete_sell, dolar_variation
    return dolar_billete_buy, dolar_billete_sell
  end

end

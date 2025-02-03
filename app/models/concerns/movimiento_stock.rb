module MovimientoStock
  extend ActiveSupport::Concern
  
  class_methods do
    def generar_number_para_movimiento_stock(last_number = 0)
      new_number = last_number + 1
      "MS-" + new_number.to_s.rjust(8,padstr= '0')
    end
  end
  
end

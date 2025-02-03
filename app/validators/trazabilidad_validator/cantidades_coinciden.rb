# Prepara para ser implementada por modelos que tengan details.
module TrazabilidadValidator::CantidadesCoinciden
  extend ActiveSupport::Concern
  
  included do
    validate :cantidad_recibida_y_trazabilidad_coinciden, on: :update, if: :quiero_confirmar
  end
  
  # Si declaro que recibi 10 unidades, y en trazabilidad suma 9, entonces hay un error.
  # Recorremos los detalles, y tambien los childs de cada detalle, en caso que sea una Caja.
  def cantidad_recibida_y_trazabilidad_coinciden
    self.details.reject{|detail| detail.marked_for_destruction? }.each do |detail|
      if detail.product.present?
        if detail.quantity != detail.batch_details.reject{|detail| detail.marked_for_destruction? }.sum(&:quantity)
          errors.add(:details, "Cantidades recibidas y trazabilidad deben coincidir para #{detail.product.try(:name)}")
        end
      end
      detail.childs.each do |child_detail|
        next if child_detail.product.nil?
        if child_detail.quantity != child_detail.batch_details.reject{|detail| detail.marked_for_destruction? }.sum(&:quantity)
          errors.add(:details, "Cantidades recibidas y trazabilidad deben coincidir para #{child_detail.product.try(:name)}")
        end
      end
    end
  end

  def quiero_confirmar
    changes[:state] == ["Pendiente", "Confirmado"]
  end
end

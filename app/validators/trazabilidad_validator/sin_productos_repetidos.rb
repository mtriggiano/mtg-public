# Prepara para ser implementada por modelos que tengan details.
module TrazabilidadValidator::SinProductosRepetidos
  extend ActiveSupport::Concern
  
  included do
    #validate :sin_productos_repetidos_en_detalles, if: :no_quiero_reabrir_documento
  end
  
  def sin_productos_repetidos_en_detalles
    _details = self.details.reject{|detail| detail.marked_for_destruction? || detail.product.nil? }
    distintos = _details.pluck(:product_id).size != _details.pluck(:product_id).uniq.size
    errors.add(:Base, "No puede repetir el producto en los detalles.") if distintos
  end

  def no_quiero_reabrir_documento
    changes[:state] != ["Finalizado", "Pendiente"] && changes[:state] != ["Confirmado", "Pendiente"]
  end
end

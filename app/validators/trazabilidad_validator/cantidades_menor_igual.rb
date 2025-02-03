# Prepara para ser implementada por modelos que tengan details.
module TrazabilidadValidator::CantidadesMenorIgual
  extend ActiveSupport::Concern
  
  included do
    validate :check_trazabilidad, on: :update
  end
  
  # Agrupamos por producto y validamos que la trazabilidad en batches no supere la cantidad recibida
  # ejemplo de un error: para el producto 1, se recibieron 3 unidades, y la trazabilidad me suma 4
  # ejemplo valido: se recibieron 3 unidades, trazabilidad me suma 2, impicitamente 1 unidad la sumo al lote S/N
  # esto a futuro debe cambiar, siemrpe se debe elegir explicitamente un lote.
  def check_trazabilidad
    self.details.reject{|detail| detail.marked_for_destruction? }.group_by(&:product_id).each do |product_id, grouped_details|
      total_recibido = grouped_details.pluck(:quantity).sum || 0
      total_en_batches = grouped_details.map{|d| d.batch_details.reject{|detail| detail.marked_for_destruction? } }.flatten.map{|bd| bd.quantity }.sum || 0
      if total_en_batches > total_recibido
        errors.add(:Base, "La cantidad total sssss en la trazabilidad no puede ser mayor a la cantidad declarada en el detalle.")
      end
    end
  end
end
    
# Preparado para ser implementada por modelos que tengan details.
module TrazabilidadValidator::CrearBatchPorDefecto
  extend ActiveSupport::Concern

  included do
    before_validation :crear_trazabilidad_por_defecto
  end
  
  def crear_trazabilidad_por_defecto
    _details = self.details.reject{|detail| detail.marked_for_destruction? }
    _details.each do |detail|
      if detail.batch_details.empty?
        if detail.product.present?
          batch_detail = detail.batch_details.build
          batch_detail.quantity = detail.quantity
          batch_detail.batch = detail.product.default_batch
        end
      end
      detail.childs.each do |child_detail|
        if child_detail.batch_details.empty?
          if child_detail.product.present?
            batch_detail = child_detail.batch_details.build
            batch_detail.quantity = child_detail.quantity
            batch_detail.batch = child_detail.product.default_batch
          end
        end
      end
    end
  end
end
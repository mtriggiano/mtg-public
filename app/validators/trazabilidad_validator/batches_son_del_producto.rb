# Prepara para ser implementada por modelos que tengan details.
module TrazabilidadValidator::BatchesSonDelProducto
  extend ActiveSupport::Concern
  
  included do
    validate :batches_deben_ser_de_producto, on: :update
  end
  
  # este error sucede cuando en el detalle de un documento cambiamos el producto, pero no cambiamos los lotes.
  # esto es un error, no deberiamos dejar que se editen los productos
  # en ese caso deberian borrar el detalle y crear uno nuevo con el producto que deseen.
  # al eliminar un detalle se deben borrar los batch_details pero no los batches
  def batches_deben_ser_de_producto
    _details = self.details.reject{|detail| detail.marked_for_destruction? }
    _details.each do |detail|
      next if detail.batches.empty? || detail.product.nil?
      if detail.batches.pluck(:product_id).uniq != [detail.product_id]
        errors.add(:Base, "Los lotes deben ser del producto. Revisar el detalle #{detail.product.name}") 
      end
    end
  end
end
  
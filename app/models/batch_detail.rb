class BatchDetail < ApplicationRecord
	belongs_to :batch
  	belongs_to :detail, polymorphic: true
	belongs_to :store, optional: true

  	accepts_nested_attributes_for :batch, reject_if: :all_blank
    validates_associated :batch
    validate :check_quantity

	before_validation :set_default_store_from_detail

  	def movement_type
	  	case detail_type
	  	when "ExpedientArrivalDetail"
	  		"Ingreso"
	  	when "ExpedientShipmentDetail"
	  		"Egreso"
	  	when "ExpedientConsumptionDetail"
	  		"Consumo"
	  	when "ExpedientDevolutionDetail"
	  		"Devolución"
	  	end
  	end

  	def document
		document = detail.try(:parent) 
		return document if is_a_document?(document.class.name)
		document = detail.try(:parent).try(:parent)
		return document if is_a_document?(document.class.name)
  	end

	# si el nombre de la clase NO incluye la palabra Detail puedo inferir que se trata de un documento
	# un ejemplo de un documento puede ser ExternalArrival o ExternalShipment
	# un ejemplo de un detail puede ser ExternalArrivalDetail o ExternalShipmentDetail
	def is_a_document?(clase)
		!clase.include?("Detail")
	end

    def batch
      Batch.unscoped { super }
    end

  	def remove_from_batch
      unless batch.nil?
    		new_quantity = batch.quantity - quantity
    		if new_quantity <= 0
    			batch.update_columns(quantity: 0, state: false)
    		else
    			batch.update_columns(quantity: new_quantity, state: true)
    		end
      end
  	end

    def check_quantity
	  errors.add(:quantity, "No puede ser mayor a la cantidad del concepto") if self.quantity > self.detail.quantity
      #errors.add(:quantity, "Cantidad de la trazabilidad debe ser mayor o igual a cero") if self.quantity <= 0
    end

    def self.search_by_supplier suppliers=[]
      return all if suppliers.blank?
      where(arrivals:{entity_id: suppliers})
      # code
    end
	
	def get_store
		self.detail.store
	end

	def set_default_store_from_detail
	  self.store = self.detail.store
	end

end

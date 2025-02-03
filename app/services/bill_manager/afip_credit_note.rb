module BillManager
	class AfipCreditNote

		def self.make_credit_note bill
      		bill.errors.add(:base, "Esta factura ya posee una nota de crédito asociada.") unless bill.credit_notes.empty?
      		bill.errors.add(:base, "No se puede generar.") unless bill.canceled? && bill.is?(:bill)
          bill.errors.add(:cbte_tipo, "Por el momento no se permite cancelar Notas de Debito por el sistema, 
            por favor darlo de baja en afip manualmente.") unless bill.is?(:bill)
          if bill.errors.empty?
            bill.update_column(:canceled, true) if clone_bill(bill).save
          else
            bill.restore_state!
            return false
          end
    	end

    	def self.clone_bill(bill)
      		old_attributes = bill.attributes.except("id", "number", "state", "cae", "cae_due_date")
      		child = eval(bill.type).new(old_attributes) do |c|
		        c.cbte_tipo   = (bill.cbte_tipo.to_i + 2).to_s.rjust(2, '0')
		        c.state       = "Confirmado"
		        c.cbte_fch    = Date.today
		        c.parent_bill = bill.id
        		bill.details.each do |detail|
          			c.details.new(detail.attributes.except("id"))
        		end
      		end
      		child.current_user = bill.current_user
      		return child
    	end
	end
end

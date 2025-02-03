module BillManager
	class Confirmator

		def self.confirm(bill)
	      	if send_to_afip?(bill)
	        	if check_cae(bill)
	        		#begin
		          		BillManager::AfipBill.establece_constantes(bill.company)
		          		comprobante = set_comprobante(bill)
		          		comprobante.authorize
		          		manage_response(bill, comprobante.response)
		          	#rescue Exception => e
		          	#	manage_exception(bill, e)
		          	#end
	          	end
					elsif bill.recently_confirmed? && bill.manual == "M"
						actualizar_comprobante_manual(bill)
	      	end
	    end

	    def self.manage_exception(bill, e)
	    	if bill.cae.blank? && bill.number.blank?
	    		bill.state 		= "En revisión"
	    		bill.afip_error = e.inspect
	    	elsif !bill.cae.blank? && bill.number.blank?
	    		bill.state 		= "En revisión"
	    		bill.afip_error = e.inspect
	    		bill.cae 		= bill.cae

	    	elsif bill.cae.blank? && !bill.number.blank?
	    		bill.state 		= "En revisión"
	    		bill.afip_error = e.inspect
	    		bill.number 	= bill.number
	    	else
	    		bill.state 		=  "En revisión"
	    		bill.afip_error = e.inspect
	    		bill.number 	= bill.number
	    		bill.cae 		= bill.cae
	    	end
	    end

	    def self.check_cae bill
	    	if bill.cae.blank?
	    		return true
	    	else
	    		bill.errors.add(:base, "Esta factura ya tiene un C.A.E. asociado. Consulte al soporte.")
	    		return false
	    	end
	    end

	    def self.manage_response bill, response
	    	if response[:header_result] == "A"
      			update_bill(bill, response)
      		else
      			manage_errors(bill, response)
      		end
	    end

	    def self.send_to_afip?(bill)
      		bill.recently_confirmed? && bill.manual == "E"
    	end

    	def self.set_comprobante bill
      		entity = bill.client
      		comprobante =  Afip::Bill.new(
		        net:            suma_montos_netos_con_descuento(bill),
		        doc_num:        0,
		        sale_point:     bill.sale_point,
		        documento:      Afip::DOCUMENTOS.key(entity.document_type),
		        moneda:         :peso,
		        iva_cond:       entity.iva_cond.parameterize.underscore.gsub(" ", "_").to_sym,
		        concepto:       bill.concept,
		        ivas:           vector_de_iva_con_descuento(bill),
		        cbte_type:      bill.cbte_tipo,
		        fch_serv_desde: bill.fch_ser_desde,
		        fch_serv_hasta: bill.fech_ser_hasta,
		        due_date:       bill.fch_vto_pago,
		        tributos:       tributos(bill),
		        cant_reg:       1,
		        no_gravado:     no_gravado(bill),
		        exento:         exento(bill),
		        otros_imp:      otros_imp(bill),
		        fch_emision:  	bill.date,
				opcionales: 	opcionales(bill),
				cbte_asoc: 		parent_bill(bill)
      		)
		    comprobante.doc_num = invoice_client_document(entity)
		    return comprobante
    	end

    	def self.suma_montos_netos_con_descuento bill
      		bill.details
      		.reject(&:marked_for_destruction?)
        	.select{|d| ["03", "04", "05", "06"].include?( d.iva_aliquot )}
					.inject(0) { |sum, detail| sum + (detail.total - detail.iva_amount) }.round(2)
		end

		def self.parent_bill bill
			if !bill.parent.nil?
				return [{cbte_tipo: bill.parent.cbte_tipo, sale_point: bill.parent.sale_point.to_i, cbte_num: bill.parent.number.to_i}]
			else
				return []
			end
		end

    	def self.opcionales bill
    		bill.optionals
    		.reject(&:marked_for_destruction?)
    		.map{|op| {id: op.afip_id, valor: op.valor}}
    	end

    	def self.vector_de_iva_con_descuento bill
      	i = Array.new
      	iva_hash = bill.details
	      	.reject(&:marked_for_destruction?)
	        .group_by{ |detail| detail.iva_aliquot }
	        .map{ |aliquot, inv_det| {
	          	aliquot: aliquot,
	          	net_amount: inv_det.sum{ |id| id.neto.to_f },
	          	iva_amount: inv_det.sum{ |s| s.iva_amount }
	        }}

      	iva_hash.each do |iva|
        	i << [ iva[:aliquot], iva[:net_amount].round(4), iva[:iva_amount].round(4) ]
      	end
      	return i
	    end

	    def self.tributos bill
	      	bill.tributes
	      	.reject(&:marked_for_destruction?)
	      	.map{|t| [t.afip_id, t.desc, t.base_imp, t.alic, t.amount]}
	    end

	    def self.no_gravado bill
	      	bill.details
	      	.reject(&:marked_for_destruction?)
	      	.select{|d| d.iva_aliquot ==  "01"}.map(&:total).reduce(0, :+).round(4)
	    end

	    def self.exento bill
	      	bill.details
	      	.reject(&:marked_for_destruction?)
	      	.select{|d| d.iva_aliquot ==  "02"}.map(&:total).reduce(0, :+).round(4)
	    end

	    def self.otros_imp bill
	      	bill.tributes
	      	.reject(&:marked_for_destruction?)
	      	.map(&:amount).reduce(0, :+).round(4)
	    end

	    def self.invoice_client_document entity
      		if entity.document_type == '99'
        		0
      		else
        		entity.document_number
      		end
    	end

    	def self.update_bill(bill, response)
	        bill.cae            	= response[:cae]
	        bill.sale_point     	= response[:pto_vta].to_s.rjust(4, '0')
	        bill.authorized_on  	= response[:authorized_on]
	        bill.cae_due_date   	= response[:cae_due_date]
	        bill.cae            	= response[:cae]
	        bill.imp_tot_conc   	= response[:imp_tot_conc]
	        bill.imp_neto       	= response[:imp_neto]
			bill.gross_amount			= response[:imp_neto]
	        bill.imp_op_ex      	= response[:imp_op_ex]
	        bill.imp_iva        	= response.to_h[:imp_iva] || 0
	        bill.total          	= response[:imp_total]
	        bill.number         	= response[:cbte_hasta].to_s.rjust(8, '0')
	        bill.document_type 		= response[:doc_tipo]
	        bill.document_number 	= response[:doc_num]
    	end

			def self.actualizar_comprobante_manual bill
				bill.imp_tot_conc   	= no_gravado(bill)
				bill.imp_neto       	= suma_montos_netos_con_descuento(bill)
				bill.gross_amount			= suma_montos_netos_con_descuento(bill)
				bill.imp_op_ex      	= exento(bill)
				bill.imp_iva        	= bill.details.reject(&:marked_for_destruction?).map(&:iva_amount).reduce(0, :+).round(4)
				bill.document_type 		= bill.client.document_type
				bill.document_number 	= bill.client.document_number
			end

    	def self.manage_errors bill, response
      		bill.errors.add(:base, "No se pudo generar el comprobante.")
      		bill.restore_state!
      		if !response[:observaciones].try(:[], :obs).blank?
        		response[:observaciones][:obs].uniq.each do |o|
	          		if o.is_a?(Hash)
	            		bill.errors.add(:base, o[:msg])
	          		else
	            		bill.errors.add(:base, response[:observaciones][:obs][:msg])
	          		end
	        	end
      		else
        		if response[:errores]
          			bill.errors.add(:base, response[:errores][:msg])
        		end
      		end
    	end
	end
end

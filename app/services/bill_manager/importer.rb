module BillManager
	class Importer
		attr_accessor :collection

		def initialize(args={})
			company  = args[:company] 
			BillManager::AfipBill.establece_constantes(company)
			@collection = []
    	end

    	def export
    		[1,2,3,6,7,8,11,12,13].each do |cbte_tipo|
    		number = 1
	    		while number
	    			result = Afip::Bill.comp_consultar(cbte_tipo, number, 6)
	    				.body[:fe_comp_consultar_response][:fe_comp_consultar_result]
	    			if result[:errors].nil? 
	    				@collection << result[:result_get]
	    				number += 1
	    			else
	    				number = false
	    			end
	    		end
	    	end
	    	return @collection
    	end

	end
end


module ProductInheritance
	extend ActiveSupport::Concern

	MERGES = {
		"Sales::BudgetDetail" 				=> [{document: :sale_requests}],
		"Sales::OrderDetail" 				=> [{document: :budgets}],
		"Sales::ShipmentDetail" 			=> [{document: :orders}, {alias: [:bills]}],
		"Sales::BillDetail" 				=> [{document: :orders}, {document: :shipments}],
		"Purchases::PurchaseRequestDetail" 	=> [{document: :sale_orders, alias:[:orders]}, {alias: [:external_arrivals]}],
		"Purchases::BudgetDetail"			=> [{document: :purchase_requests}],
		"Purchases::OrderDetail" 			=> [{document: :purchase_requests}, {document: :budgets}],
		"Purchases::DevolutionDetail" 		=> [{document: :external_arrivals, source: :all_details}],
		"ExternalBillDetail" 				=> [{document: :external_arrivals, source: :all_details}, {document: :expedient_orders, source: :all_details, alias: [:orders, :expedient_orders]}],
		"ExternalArrivalDetail" 			=> [{document: :expedient_requests, source: :all_details, alias: [:purchase_requests, :supplier_requests, :devolutions]}, {document: :expedient_orders, source: :all_details}],
		"Surgeries::BudgetDetail"			=> [{document: :prescriptions}],
		"Surgeries::SaleOrderDetail"		=> [{document: :budgets}],
		"Surgeries::ShipmentDetail"			=> [{document: :sale_orders}, {alias: [:arrivals, :consumptions, :client_bills]}],
		"Surgeries::PurchaseRequestDetail"	=> [{document: :shipments}],
		"Surgeries::SupplierRequestDetail"	=> [{document: :purchase_requests, source: :details}],
		"Surgeries::ConsumptionDetail"		=> [{document: :shipments}],
		"Surgeries::DevolutionDetail"		=> [{document: :external_arrivals}, {document: :shipments}, {document: :consumptions}],
		"Surgeries::PurchaseOrderDetail" 	=> [{document: :consumptions}, {documents: :external_bills, source: :all_details}],
		"Surgeries::ClientBillDetail"		=> [{document: :sale_orders}, {document: :shipments}, {alias: [:shipments, :consumptions]}],
	}

	included do
		attr_accessor :merge_with
		attr_accessor :available_quantity

		set_merge_relationships

		def merge_with_associated_document_details
			MERGES[self.class.name].each do |ad|
				if ad[:document]
					if self.class.column_names.include?('approved_quantity')
						@available_quantity = approved_quantity
					else
						@available_quantity = quantity
					end
					eval("#{ad[:document].to_s}_details").each do |associated_product|
						eval("#{for_eval(associated_product)} = id")
						eval("#{for_eval(associated_product, "custom_detail_id")} = id")
						eval("#{for_eval(associated_product, "state")} = parent.state")
						eval("#{for_eval(associated_product, "quantity")} = #{for_eval(associated_product, 'quantity')}.to_i #{merge_operation} #{to_assign(associated_product)}")
						associated_product.save
					end
				end
			end
		end

		def to_assign(associated_product)
			if merge_operation == "-"
				left_quantity = eval(for_eval(associated_product, "quantity")).to_i
			else
				if associated_product.class.column_names.include?('approved_quantity')
					left_quantity = associated_product.approved_quantity - eval(for_eval(associated_product, "quantity")).to_i
				else
					left_quantity = associated_product.quantity - eval(for_eval(associated_product, "quantity")).to_i
				end
			end

			if left_quantity.to_i < @available_quantity.to_i
				@available_quantity -= left_quantity
				result = left_quantity
			else
				result =  available_quantity
				@available_quantity = 0
			end
			return result
		end

		def for_eval(associated_product, attribute=nil)
			if attribute
				"associated_product.#{self.class.table_alias.gsub("_details", "").singularize}_#{attribute}"
			else
				"associated_product.#{self.class.table_alias.gsub("_details", "").singularize}ed"
			end
		end

  		def merge_operation
  			capture yield if block_given?
          	if parent.need_unmerge?
                return "-"
            elsif parent.confirmed?
                return "+"
            else
            	return "-"
            end
		end
	end

	class_methods do

		def set_merge_relationships
			unless MERGES[name].nil?
				MERGES[name].each do |ad|
					if ad[:document]
						has_many ad[:document], through: name.demodulize.gsub("Detail", "").snakecase.to_sym
						has_many "#{ad[:document].to_s}_details".to_sym, ->(detail){ where(product_name: detail.product_name) }, through: ad[:document], source: ad[:source] || :details
						name.gsub("Detail", "").constantize.after_save :merge_details
						name.gsub("Detail", "").constantize.define_method "merge_details" do
							details.each(&:merge_with_associated_document_details) if saved_change_to_state? && need_merge?
						end
					end
				end
			end

			MERGES.each do |key,values|
				values.each do |value|
					sym_name = name.demodulize.gsub("Detail", "").pluralize.snakecase.to_sym
					if value[:document] == sym_name || (value[:alias] && value[:alias].include?(sym_name) )
						set_custom_attributes( key.constantize.table_alias.gsub("_details", "") )
					end
				end
			end

		end

		def set_custom_attributes attr_name
			store_accessor :custom_attributes, "#{attr_name}ed".to_sym
			store_accessor :custom_attributes, "#{attr_name}_custom_detail_id".to_sym
			store_accessor :custom_attributes, "#{attr_name}_state".to_sym
			store_accessor :custom_attributes, "#{attr_name}_quantity".to_sym
		end
	end
end

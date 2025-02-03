module Purchases::PurchaseReturnsHelper

	def return_batch_td builder
		record = builder.object
		if record.product_id.nil?
			builder.input :batch_id, disabled: true, prompt: "Seleccione producto"
		else
			builder.input :batch_id,
			as: :select,
			disabled: (record.product.nil? || devolution.disabled?), 
			prompt: record.batch_prompt,
			collection: [[record.batch.try(:code), record.batch.try(:id)]],
			input_html: {
				data: {
					url: availables_product_batches_path(record.product_id)
				}
			}
		end
	end
end

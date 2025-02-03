class Surgeries::DevolutionsController < ApplicationController
  include Attachable
  include Fileable
  include CanAddDetail
  include Indexable
  include ClientFilter
  include Reopen
  include BasicCrud
  include Traceable

	private

		def devolution_params
			params.require(:surgeries_devolution).permit(:number, :store_id, :entity_id, :file_id, :date, :state, :observation, :shipping_price, :shipment_number,
				details_attributes: [:id, :number, :product_id, :product_name, :product_measurement, :return_reason, :quantity, :total, :_destroy,
          batch_details_attributes: [:id, :quantity, :batch_id, :_destroy],
          childs_attributes: [:id, :number, :product_id, :product_name, :product_measurement, :return_reason, :quantity, :total, :_destroy,
            batch_details_attributes: [:id, :quantity, :batch_id, :_destroy]
          ]
        ],
        devolutions_external_arrivals_attributes: [:id, :arrival_id, :_destroy],
        attachments_attributes: [:id, :file, :original_filename, :_destroy],
				custom_attributes: current_company.purchase_devolution_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
  			devolutions_consumptions_attributes: [:id, :consumption_id, :_destroy],
        devolutions_shipments_attributes: [:id, :shipment_id, :_destroy],
			)
		end

end

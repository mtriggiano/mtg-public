class Purchases::DevolutionsController < ApplicationController
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
			params.require(:purchases_devolution).permit(:number, :user_id, :entity_id, :file_id, :date, :state, :observation, :shipping_price, :store_id,
				details_attributes: [:id, :number, :product_id, :product_name, :product_measurement, :return_reason, :quantity, :total, :_destroy,
          batch_details_attributes: [:id, :batch_id, :quantity, :_destroy],
          gtin_attributes: [:id, :code],
          childs_attributes: [:id, :number, :product_id, :product_name, :product_measurement, :return_reason, :quantity, :total, :_destroy,
            batch_details_attributes: [:id, :batch_id, :quantity, :_destroy],
            gtin_attributes: [:id, :code],
          ]
        ],
        attachments_attributes: [:id, :file, :original_filename, :_destroy],
				custom_attributes: current_company.purchase_devolution_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
  			devolutions_external_arrivals_attributes: [:id, :arrival_id, :_destroy]
			)
		end

end

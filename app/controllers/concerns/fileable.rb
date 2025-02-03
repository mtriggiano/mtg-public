module Fileable
	extend ActiveSupport::Concern

	included do
		expose controller_name.to_sym,
			->{
					eval(
						"current_company.#{
							controller_path.split("/")
							.map(&:singularize)
							.join("_")
							.pluralize
						}"
					)
					.belongs_to_file(params[:file_id] || params[:extra_data])
					.search(params[:q])
				}
		expose controller_name.singularize.to_sym, scope: -> {eval(controller_name)}, model: controller_path.classify
	end
end

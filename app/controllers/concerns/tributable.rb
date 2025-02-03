module Tributable
	extend ActiveSupport::Concern

  included do
    helper_method :record
    skip_load_and_authorize_resource only: :add_tributes
  end

	def add_tributes
    client = record.file.try(:client)
    unless client.nil?
      if client.iibb_perception
        record.add_tributes(client.iibb_aliquot)
      end
    end
  end

  private
		def record
			eval(controller_name.singularize)
		end
end

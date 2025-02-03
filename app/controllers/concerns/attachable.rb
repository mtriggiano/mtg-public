module Attachable
	extend ActiveSupport::Concern

	included do
		before_action :set_s3_direct_post, only: [:show, :new, :edit, :create, :update]
	end
end

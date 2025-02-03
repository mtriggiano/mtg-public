module Restricted
	extend ActiveSupport::Concern

	included do
		#TODO agregar delegaciones
		scope :only_allowed, -> (user) {
			left_outer_joins(:file, :file => :responsables)
			.where("(#{table_name}.user_id = ?) OR (file_responsables.document_type = ? AND file_responsables.user_id = ?)", user.id, name.snakecase, user.id) unless user.can?(:manage, :all) || user.can?(:manage, name)}


		def has_permission?(user)
	      user.can?(:approve, self.class)
		end

		def self.belongs_to_file(file_id)
			if not file_id.blank?
				where(file_id: file_id)
			else
				all
			end
		end

	end
end

class PaperTrail::VersionPresenter < BasePresenter
	presents :version
	delegate_missing_to :version

	def title
		"Actualización #{l(version.created_at, format: :short)}"
	end

	def user
		User.find_by(id: version.version_author)
	end

	def version_author
		if user
			see_contact_dl("Cambios realizados por", "#{image_tag(user.avatar, class: 'rounded-circle user-avatar mx-2')} #{user.name}") 
		else
			see_contact_dl("Cambios realizados por", "Consola")
		end 
	end

	def changes
		content_tag :div do
			version.changeset.each do |attr, change|
				if change.first.is_a?(Hash)
					changes = change.first.merge(change.last) { |_k, v1, v2| v1 == v2 ? nil : :different }.compact.keys
					changes.each do |subchange|
						concat see_contact_dl(I18n.t("activerecord.attributes.expedient.#{subchange}"), "#{change.first[subchange]} => #{change.last[subchange]}")
					end
				else
					concat see_contact_dl(I18n.t("activerecord.attributes.expedient.#{attr}"), "#{change.first} => #{change.last}")
				end
			end
		end
	end
end
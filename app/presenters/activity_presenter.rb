class ActivityPresenter < BasePresenter
	presents :activity
	delegate :id, to: :activity
	delegate :body, to: :activity
	delegate :activity_type, to: :activity
	
	def title
		link_to activity.title, activity.link
	end

	def action_links
		content_tag :div do
			concat(link_to_show activity_path(activity), remote: true)
		end
	end



end

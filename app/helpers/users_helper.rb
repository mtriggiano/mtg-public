module UsersHelper

	def company_logo(user)
		if user.nil? || current_company.nil?
			image_tag "/images/default_logo.png", class: 'img-fluid fit-shadow nav-banner'
		else
			image_tag current_company.logo, class: 'img-fluid fit-shadow nav-banner'
		end
	end
	
end
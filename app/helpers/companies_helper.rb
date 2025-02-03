module CompaniesHelper
	def config_links(text, view, current_view, path)
		if current_view == view
			link_to text.html_safe, path, class: 'nav-link bg-secondary text-white'
		else
			link_to text.html_safe, path, class: 'nav-link text-dark border border-bottom-0'
		end
	end

	def see_company_dl(text, value)
		html = <<-HTML
			<div class='row'>
				<dt class='col-md-4 col-6 text-right'>#{text}</dt>
				<dd class='col-md-8 col-6'>#{value}</dd>
			</div>
		HTML
	    return html.html_safe
	end


	def client_card(size, text, explanation, i, color)

		html = <<-HTML
		<div class='col-md-#{size} col-12 col-sm-6 mt-2'>
			<div class='card'>
				<div class='card-body p-2'>
					<div class='font-weight-light small text-right'>
						#{explanation}
					</div>
					<h4 class='text-right font-weight-bold'>
						#{text}
					</h4>
				</div>
			</div>
		</div>
		HTML
		return html.html_safe
	end

	def user_card(size, text, explanation, i, color, img_source)

		html = <<-HTML
		<div class='col-md-#{size} col-12 col-sm-6 mt-2'>
			<div class='card bg-#{color} p-2 text-white-50 shadow'>
				<div class='row'>
					<div class='col-2'>
						 <div class="profile-thumbnail" style="background: url(#{img_source});" width="10%">
					</div>
					<div class='col-10'>
						<div class='font-weight-bold text-center'>
							<h4 class='text-truncate'>
								#{text}
							</h4>
						</div>
						<div class='font-weight-light small text-right pt-4'>
							#{explanation}
						</div>
					</div>
				</div>
			</div>
		</div>
		HTML
		return html.html_safe
	end

	def state_card(size, text, explanation, i, color)
		html = <<-HTML
		<div class='card bg-#{color} p-2 shadow mb-2 mx-1 text-center'>
			<h5>
				#{text}
			</h5>
			<h5>
				#{icon('fas', i)}
				#{explanation}
			</h5>
		</div>
		HTML
		return html.html_safe
	end
end

class Reports::ClientPresenter < BasePresenter
	presents :client

	def name
		link_to client.name, client
	end

	def current_balance
		color =  client.current_balance < 0 ? 'danger' : 'success'
		content_tag :div, class: "text-right text-#{color}" do
			number_to_ars client.current_balance
		end
	end

	def action_links
		content_tag :div, class: 'text-center' do
			concat (link_to_pdf reports_client_path(client,format: :pdf))
		end
	end
end
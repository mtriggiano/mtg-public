module PaginateHelper

	def paginate resource, param_name = nil
		@resource = resource
		@param_name = param_name
		content_tag :div, style: 'width: 100%' do
			concat(will_paginate_helper)
			concat(javascript_paginate_helper)
		end
	end
	def will_paginate_helper
		will_paginate @resource,
			list_classes: %w(pagination justify-content-center),
			:page_links => true,
		 	:inner_window => 1,
			:outer_window => 1,
			:param_name => @param_name || "page",
			:previous_label => '← Anterior',
			:next_label => 'Siguiente →',
			renderer: WillPaginate::ActionView::BootstrapLinkRenderer
	end

	def javascript_paginate_helper
		javascript_tag("$('ul.pagination a').click(function(){$.getScript(this.href); return false; });")
	end

end

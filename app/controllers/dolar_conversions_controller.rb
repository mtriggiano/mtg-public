class DolarConversionsController < ApplicationController
	skip_load_and_authorize_resource

	include DolarCotization

end

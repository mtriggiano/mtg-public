class HumanResources::UserRolesController < ApplicationController
    skip_load_and_authorize_resource
    expose :user
    expose :roles, ->{user}
    expose :role, scope: ->{roles}
    
    def index
		if request.format.json?
            #authorize! :read, obj
            render json: ::RoleDatatable.new(params, view_context: view_context, collection: user.roles), status: 200
		end
	end

    def new
        pp user
    end

    def edit
    end
end
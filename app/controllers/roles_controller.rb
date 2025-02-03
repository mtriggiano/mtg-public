class RolesController < ApplicationController
  expose :roles,  ->{ current_company.roles }
  expose :role, scope: ->{ roles }
  include Indexable
  include BasicCrud

  protected
    def role_params
      params.require(:role).permit(:id, :name, abilities_attributes: [:id, :class_name, :_destroy, ability_actions: []])
    end
end

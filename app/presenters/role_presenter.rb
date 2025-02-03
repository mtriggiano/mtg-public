class RolePresenter < BasePresenter
    presents :role
    delegate :name, to: :role
    delegate :id, to: :role

    def action_links
      content_tag :div do
        # concat(link_to_show role)
        concat(link_to_edit [:edit, role], {data:{target: "#edit_role_modal", toggle: "modal", form: true}})
        concat(link_to_destroy role) if request.path == "/roles.json"
      end
    end
end

class StoreUserDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def initialize(params, opts = {})
    @view = opts[:view_context]
    @store ||= opts[:store]
    super
  end

  def_delegator :@view, :present

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id:           { source: "User.id", searchable: false},
      name: 		    { source: "User.last_name", cond: :like},
      role:         { source: "Role.friendly_name", cond: :like },
      phone:  		  { source: "User.phone", cond: :like},
      state:        {},
      links: {}
    }
  end

  def data
    records.map do |record|
      presenter = UserPresenter.new(record, @view)
      {
        id:           record.id,
        name: 		    presenter.name,
        role:         presenter.role,
        phone:  	    presenter.phone,
        state:        presenter.state,
        actions:      presenter.action_links
      }
    end
  end

  def get_raw_records
    @store.users.includes(:roles)
  end

end

class TransferNoteDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def initialize(params, opts = {})
    @view = opts[:view_context]
    @store ||= opts[:store]
    super
  end


  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id:               { source: "TransferNote.id", cond: :eq },
      number:           { source: "TransferNote.number", cond: :start_with },
      sended_date:      { source: "TransferNote.sended_date", cond: :like },
      arrival_date:     { source: "TransferNote.arrival_date", cond: :like },
      state:            { source: "TransferNote.state", cond: :like},
      links: {}
    }
  end

  def data
    records.map do |record|
      presenter = TransferNotePresenter.new(record, @view)
      {
        id:              record.id,
        number:          presenter.number,
        sended_date:     presenter.sended_date,
        arrival_date:    presenter.arrival_date,
        state:           presenter.state,
        actions:         presenter.action_links
      }
    end
  end

  def get_raw_records
    @store.transfer_notes
  end

end

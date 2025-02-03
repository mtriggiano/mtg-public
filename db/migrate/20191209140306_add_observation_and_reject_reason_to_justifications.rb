class AddObservationAndRejectReasonToJustifications < ActiveRecord::Migration[5.2]
  def change
    add_column :justifications, :observation, :text
    add_column :justifications, :reject_reason, :string
  end
end

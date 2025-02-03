class AddStateToAtachments < ActiveRecord::Migration[5.2]
  def change
    add_column :attachments, :state, :integer, null: false, default: 0
  end
end

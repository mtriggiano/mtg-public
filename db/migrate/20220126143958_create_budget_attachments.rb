class CreateBudgetAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :budget_attachments do |t|
      t.string :file, default: "/images/attachment.png", null: false
      t.string :original_filename
      t.boolean :active, default: true
      t.bigint :file_id
      t.bigint :entity_id
      t.string :entity_name
      t.string :detail
      t.string :objeto
      t.timestamps
    end
  end
end

class AddPrincipalAttachmentToPermissions < ActiveRecord::Migration[5.2]
  def change
    add_column :justifications, :principal_attachment, :string, default: "/images/attachment.png"
  end
end

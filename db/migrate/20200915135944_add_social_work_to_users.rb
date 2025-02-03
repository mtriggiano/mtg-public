class AddSocialWorkToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :social_work, :string
  end
end

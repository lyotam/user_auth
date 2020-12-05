class AddEncFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :encrypted_password, :string
    add_column :users, :encrypted_token, :string
  end
end

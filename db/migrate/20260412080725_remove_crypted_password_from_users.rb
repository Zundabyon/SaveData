class RemoveCryptedPasswordFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :crypted_password, :integer
  end
end

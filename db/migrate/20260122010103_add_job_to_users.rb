class AddJobToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :job, :string
  end
end

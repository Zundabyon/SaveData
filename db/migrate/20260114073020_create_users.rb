class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.date :birthday
      t.boolean :gender
      t.integer :crypted_password
      t.string :job
      t.timestamps
    end
  end
end

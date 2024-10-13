class CreateAdmins < ActiveRecord::Migration[7.2]
  def change
    create_table :admins do |t|
      t.integer :id
      t.string :name
      t.string :email
      t.integer :preference
      t.string :password
      t.string :avator

      t.timestamps
    end
  end
end

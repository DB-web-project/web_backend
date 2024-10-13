class CreateBusinesses < ActiveRecord::Migration[7.2]
  def change
    create_table :businesses do |t|
      t.string :name
      t.integer :tag
      t.float :score
      t.string :email
      t.integer :preference
      t.string :password
      t.string :avator

      t.timestamps
    end
  end
end

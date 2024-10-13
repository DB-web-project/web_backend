class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.integer :post_id
      t.integer :publisher
      t.string :publisher_type
      t.string :date
      t.string :content
      t.integer :likes

      t.timestamps
    end
  end
end

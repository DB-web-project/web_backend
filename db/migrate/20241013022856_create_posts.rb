class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.integer :publisher
      t.string :publisher_type
      t.string :date
      t.integer :likes
      t.string :content

      t.timestamps
    end
  end
end

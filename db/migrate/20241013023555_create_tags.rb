class CreateTags < ActiveRecord::Migration[7.2]
  def change
    create_table :tags do |t|
      t.integer :id
      t.string :tag1
      t.string :tag2
      t.string :tag3
      t.string :tag4
      t.string :tag5

      t.timestamps
    end
  end
end

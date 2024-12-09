class CreateLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :comment_id

      t.timestamps
    end
  end
end

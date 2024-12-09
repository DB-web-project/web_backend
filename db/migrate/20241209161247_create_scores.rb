class CreateScores < ActiveRecord::Migration[7.2]
  def change
    create_table :scores do |t|
      t.integer :user_id
      t.integer :commodity_id
      t.decimal :score

      t.timestamps
    end
  end
end

class CreatePreferences < ActiveRecord::Migration[7.2]
  def change
    create_table :preferences do |t|
      t.string :preference1
      t.string :preference2
      t.string :preference3
      t.string :preference4
      t.string :preference5

      t.timestamps
    end
  end
end

class CreateCommodities < ActiveRecord::Migration[7.2]
  def change
    create_table :commodities do |t|
      t.integer :id
      t.string :name
      t.float :price
      t.float :score
      t.string :introduction
      t.integer :business_id
      t.string :homepage

      t.timestamps
    end
  end
end

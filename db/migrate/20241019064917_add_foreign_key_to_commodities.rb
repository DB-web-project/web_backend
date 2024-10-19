class AddForeignKeyToCommodities < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :commodities, :businesses, column: :business_id
    add_index :commodities, :business_id
  end
end

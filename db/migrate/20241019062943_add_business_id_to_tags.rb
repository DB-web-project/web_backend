class AddBusinessIdToTags < ActiveRecord::Migration[7.2]
  def change
    add_column :tags, :business_id, :integer, null: false
    add_foreign_key :tags, :businesses, column: :business_id
    add_index :tags, :business_id
  end
end

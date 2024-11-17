class AddRatingCountToCommodities < ActiveRecord::Migration[7.2]
  def change
    add_column :commodities, :rating_count, :integer
  end
end

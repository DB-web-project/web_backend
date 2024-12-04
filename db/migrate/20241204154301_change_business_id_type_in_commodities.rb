class ChangeBusinessIdTypeInCommodities < ActiveRecord::Migration[7.2]
  def change
    change_column :commodities, :business_id, :bigint
  end
end

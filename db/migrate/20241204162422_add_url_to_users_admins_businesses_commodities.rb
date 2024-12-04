class AddUrlToUsersAdminsBusinessesCommodities < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :url, :string
    add_column :admins, :url, :string
    add_column :businesses, :url, :string
    add_column :commodities, :url, :string
  end
end

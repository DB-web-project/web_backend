class RemovePreference < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :preference, :integer
    remove_column :admins, :preference, :integer
    remove_column :businesses, :preference, :integer
  end
end

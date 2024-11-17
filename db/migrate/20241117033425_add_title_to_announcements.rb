class AddTitleToAnnouncements < ActiveRecord::Migration[7.2]
  def change
    add_column :announcements, :title, :string
  end
end

class CreateAnnouncements < ActiveRecord::Migration[7.2]
  def change
    create_table :announcements do |t|
      t.integer :id
      t.string :date
      t.string :content
      t.integer :publisher

      t.timestamps
    end
  end
end

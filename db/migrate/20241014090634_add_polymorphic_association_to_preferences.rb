class AddPolymorphicAssociationToPreferences < ActiveRecord::Migration[7.2]
  def change
    add_reference :preferences, :preferable, polymorphic: true, null: false, index: true
  end
end

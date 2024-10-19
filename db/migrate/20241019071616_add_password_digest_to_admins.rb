class AddPasswordDigestToAdmins < ActiveRecord::Migration[7.2]
  def change
    add_column :admins, :password_digest, :string
  end
end

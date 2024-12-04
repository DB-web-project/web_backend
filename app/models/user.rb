class User < ApplicationRecord
  has_one :preference, as: :preferable, dependent: :destroy
  has_secure_password
  mount_uploader :avator, ImageUploader

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end

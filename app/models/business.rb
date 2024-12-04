class Business < ApplicationRecord
  has_one :preference, as: :preferable, dependent: :destroy # 自动删除关联的偏好设置
  has_one :tag, dependent: :destroy
  has_many :commodities, dependent: :destroy
  has_secure_password
  mount_uploader :avator, ImageUploader

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end

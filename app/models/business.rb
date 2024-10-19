class Business < ApplicationRecord
  has_one :preference, as: :preferable, dependent: :destroy
  has_one :tag

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end

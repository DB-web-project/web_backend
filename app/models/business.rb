class Business < ApplicationRecord
  has_one :preference, as: :preferable, dependent: :destroy
  has_one :tag
  has_many :commodities

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end

class User < ApplicationRecord
  has_one :preference, as: :preferable, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end

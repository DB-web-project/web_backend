class User < ApplicationRecord
  has_one :preference

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end

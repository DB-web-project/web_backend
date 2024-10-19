class Commodity < ApplicationRecord
  belongs_to :business

  validates :name, presence: true, uniqueness: true
end

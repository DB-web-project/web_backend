class Commodity < ApplicationRecord
  belongs_to :business
  mount_uploader :image, ImageUploader

  validates :name, presence: true, uniqueness: true
end

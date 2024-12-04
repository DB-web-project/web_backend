class Commodity < ApplicationRecord
  belongs_to :business
  mount_uploader :homepage, ImageUploader

  validates :name, presence: true, uniqueness: true
end

class Course < ApplicationRecord
  validates :name, :price, :code, presence: true
  validates :code, uniqueness: true

  has_one_attached :banner
end

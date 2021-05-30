class Instructor < ApplicationRecord
  has_many :courses, dependent: :destroy

  def display_name
    "#{name} - #{email}"
  end
end

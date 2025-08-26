class Region < ApplicationRecord
  has_many :districts, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end

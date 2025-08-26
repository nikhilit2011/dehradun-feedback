class District < ApplicationRecord
  
  
  has_many :schools, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end

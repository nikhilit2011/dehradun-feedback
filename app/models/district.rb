class District < ApplicationRecord
  belongs_to :region
  
  has_many :schools, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end

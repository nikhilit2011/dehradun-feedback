class School < ApplicationRecord
  belongs_to :district
  has_many :feedbacks, dependent: :destroy
  validates :name, presence: true
end

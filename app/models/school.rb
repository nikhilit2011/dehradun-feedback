class School < ApplicationRecord
  belongs_to :district
  has_many :feedbacks, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :district_id, message: "already exists in this district" }
end
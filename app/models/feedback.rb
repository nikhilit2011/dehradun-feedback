class Feedback < ApplicationRecord
  belongs_to :school
  delegate :district, to: :school
  before_validation { self.submitted_at ||= Time.current }
  validates :parent_name, :contact, :school_id, presence: true

  # Ratings: allow blank, but if present must be 1..5
  with_options allow_nil: true do
    validates :punctuality_rating, :safety_rating, :cleanliness_rating,
              :driver_behavior_rating, :seat_availability_rating,
              inclusion: { in: 1..5 }
  end

  # Issue bitmask
  ISSUES = {
    overcrowding:      1 << 0,
    rash_driving:      1 << 1,
    no_attendant:      1 << 2,
    late_arrival:      1 << 3,
    permit_expired:    1 << 4,
    fitness_expired:   1 << 5,
    gps_off:           1 << 6,
    no_seat_belts:     1 << 7,
    route_deviation:   1 << 8,
    other:             1 << 9
  }.freeze

  def issues=(arr)
    self.issues_mask = Array(arr).map(&:to_sym).inject(0) { |sum, k| sum | ISSUES[k] }
  end

  def issues
    ISSUES.keys.select { |k| issues_mask.to_i & ISSUES[k] > 0 }
  end
end

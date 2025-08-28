class Feedback < ApplicationRecord
  belongs_to :school
  delegate :district, to: :school
  before_validation { self.submitted_at ||= Time.current }
  validates :parent_name, :contact, :school_id, presence: true

  # Ratings: allow blank, but if present must be 1..5
  with_options allow_nil: true do
    validates :overall_rating, inclusion: { in: 1..5 }
  end

  # Issue bitmask
  ISSUES = {
    rash_driving:        1 << 1,
    late_arrival:        1 << 2,
    permit_missing:      1 << 3,
    tax_due:             1 << 4,
    fitness_expired:     1 << 5,
    gps_access:          1 << 6,
    no_seat_belts:       1 << 7,
    route_deviation:     1 << 8,
    other:               1 << 9,
    dl_available:        1 << 10,
    punctuality:         1 << 11,
    safety:              1 << 12,
    cleanliness:         1 << 13,
    driver_behaviour:    1 << 14
  }.freeze

  def issues=(arr)
    self.issues_mask = Array(arr).map(&:to_sym).inject(0) { |sum, k| sum | ISSUES[k] }
  end

  def issues
    ISSUES.keys.select { |k| issues_mask.to_i & ISSUES[k] > 0 }
  end
end

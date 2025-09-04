class Feedback < ApplicationRecord
  belongs_to :school, optional: true   # allow nil if "Other" is chosen
  delegate :district, to: :school, allow_nil: true

  before_validation { self.submitted_at ||= Time.current }

  # ✅ Normalize vehicle number before validation
  before_validation :normalize_vehicle_number
  before_validation :normalize_school_id

  validates :parent_name, :contact, presence: true

  validates :vehicle_number, presence: true, format: { 
    with: /\A[A-Z]{2}\d{2}[A-Z]{2}\d{4}\z/,
    message: "must be in format UK07PA1234 (2 letters, 2 digits, 2 letters, 4 digits)"
  }, length: { is: 10 }

  validates :vehicle_category, presence: true
  validates :other_issue_text, presence: true, if: -> { issues.include?(:others) }

  # ✅ School / Other School validation
  validate :validate_school_or_other

  # Ratings
  with_options allow_nil: true do
    validates :overall_rating, inclusion: { in: 1..5 }
  end

  # === Issues (bitmask) ===
  ISSUES = {
    valid_permit:       1 << 1,
    valid_fitness:      1 << 2,
    valid_insurance:    1 << 3,
    tax_paid:           1 << 4,
    cleanliness:        1 << 5,
    cctv:               1 << 6,
    gps_access:         1 << 7,
    valid_dl:           1 << 8,
    seat_belt:          1 << 9,
    female_attendant:   1 << 10,
    others:             1 << 11
  }.freeze

  def issues=(arr)
    self.issues_mask = Array(arr).map(&:to_sym).inject(0) { |sum, k| sum | ISSUES[k] }
  end

  def issues
    ISSUES.keys.select { |k| issues_mask.to_i & ISSUES[k] > 0 }
  end

  def issues_humanized
    issues.map { |k| k.to_s.humanize }
  end

  private

  def normalize_vehicle_number
    self.vehicle_number = vehicle_number.to_s.upcase.delete(" ") if vehicle_number.present?
  end

  # ✅ If school_id = "other", set it to nil (so Rails doesn’t try to save a string in integer column)
  def normalize_school_id
    self.school_id = nil if school_id.to_s == "other"
  end

  # ✅ Custom validation for school vs other_school_name
  def validate_school_or_other
    if school_id.blank? && other_school_name.blank?
      errors.add(:school_id, "must be selected or specify 'Other' school name")
    elsif school_id.nil? && other_school_name.blank?
      errors.add(:other_school_name, "must be provided when selecting 'Other'")
    end
  end
end

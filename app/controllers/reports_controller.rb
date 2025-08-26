# app/controllers/reports_controller.rb
require "csv"

class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { require_roles!(:rto_user) }

  def index
    # Unordered base scope for aggregates (prevents PG::GroupingError)
    all_fb = Feedback.includes(school: :district)

    # Ordered scope for tables/CSV display
    @feedbacks = all_fb.order(created_at: :desc)

    # -------- Summary numbers --------
    @total_feedbacks = all_fb.count
    @avg_ratings = {
      punctuality: all_fb.average(:punctuality_rating)&.round(2),
      safety:      all_fb.average(:safety_rating)&.round(2),
      cleanliness: all_fb.average(:cleanliness_rating)&.round(2),
      driver:      all_fb.average(:driver_behavior_rating)&.round(2),
      seat:        all_fb.average(:seat_availability_rating)&.round(2)
    }

    # -------- Issues aggregation (hash of issue => count) --------
    issues_count = Hash.new(0)
    all_fb.find_each do |fb|
      fb.issues.each { |i| issues_count[i] += 1 }
    end
    @top_issues = issues_count.sort_by { |_k, v| -v }.first(3).to_h

    # -------- Charts (use unordered base) --------
    @feedbacks_over_time = all_fb.reorder(nil).group_by_day(:created_at, time_zone: Time.zone.name).count
    @safety_by_district  = all_fb.reorder(nil).joins(:school).group("districts.name").average(:safety_rating)
    @issues_chart        = issues_count

    respond_to do |format|
      format.html
      format.csv do
        send_data(
          build_feedbacks_csv(@feedbacks), # export uses ordered scope
          filename: "feedbacks-#{Time.current.strftime('%Y%m%d-%H%M')}.csv",
          type: "text/csv"
        )
      end
    end
  end

  private

  def build_feedbacks_csv(scope)
    CSV.generate(headers: true) do |csv|
      csv << [
        "Submitted At",
        "District",
        "School",
        "Parent",
        "Contact",
        "Punctuality",
        "Safety",
        "Cleanliness",
        "Driver Behaviour",
        "Seat Availability",
        "Issues",
        "Comments"
      ]

      scope.find_each do |fb|
        csv << [
          fb.created_at&.iso8601,
          fb.school&.district&.name,
          fb.school&.name,
          fb.parent_name,
          fb.contact,
          fb.punctuality_rating,
          fb.safety_rating,
          fb.cleanliness_rating,
          fb.driver_behavior_rating,
          fb.seat_availability_rating,
          fb.issues.present? ? fb.issues.map { |i| i.to_s.humanize }.join("; ") : nil,
          fb.comments&.to_s&.gsub(/\s+/, " ")
        ]
      end
    end
  end
end

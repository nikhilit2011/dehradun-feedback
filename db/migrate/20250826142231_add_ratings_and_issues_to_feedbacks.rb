class AddRatingsAndIssuesToFeedbacks < ActiveRecord::Migration[7.1]
  def change
    add_column :feedbacks, :punctuality_rating, :integer
    add_column :feedbacks, :safety_rating, :integer
    add_column :feedbacks, :cleanliness_rating, :integer
    add_column :feedbacks, :driver_behavior_rating, :integer
    add_column :feedbacks, :seat_availability_rating, :integer
    add_column :feedbacks, :issues_mask, :integer
  end
end

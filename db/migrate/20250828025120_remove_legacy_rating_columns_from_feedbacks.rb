class RemoveLegacyRatingColumnsFromFeedbacks < ActiveRecord::Migration[7.1]
  def change
    remove_column :feedbacks, :punctuality_rating, :integer
    remove_column :feedbacks, :safety_rating, :integer
    remove_column :feedbacks, :cleanliness_rating, :integer
    remove_column :feedbacks, :driver_behavior_rating, :integer
    remove_column :feedbacks, :seat_availability_rating, :integer
  end
end

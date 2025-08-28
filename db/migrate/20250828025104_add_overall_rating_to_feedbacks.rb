class AddOverallRatingToFeedbacks < ActiveRecord::Migration[7.1]
  def change
    add_column :feedbacks, :overall_rating, :integer
  end
end

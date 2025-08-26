class AddVehicleNumberToFeedbacks < ActiveRecord::Migration[7.1]
  def change
    add_column :feedbacks, :vehicle_number, :string
  end
end

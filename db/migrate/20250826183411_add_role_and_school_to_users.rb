class AddRoleAndSchoolToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :integer, default: 0, null: false
    add_reference :users, :school, foreign_key: true
  end
end

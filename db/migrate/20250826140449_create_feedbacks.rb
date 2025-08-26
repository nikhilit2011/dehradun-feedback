class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.references :school, null: false, foreign_key: true
      t.string :parent_name
      t.string :contact
      t.text :comments
      t.datetime :submitted_at
      t.string :source_ip

      t.timestamps
    end
  end
end

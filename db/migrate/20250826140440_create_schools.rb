class CreateSchools < ActiveRecord::Migration[7.1]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :udise_code
      t.references :district, null: false, foreign_key: true

      t.timestamps
    end
  end
end

# db/migrate/XXXXXXXXXXXXXX_remove_region_from_districts.rb
class RemoveRegionFromDistricts < ActiveRecord::Migration[7.1]
  def change
    # This drops the foreign key (if present), index, and the region_id column
    remove_reference :districts, :region, foreign_key: true, index: true
  end
end
class CreatePortalAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string "census_block_group"
      t.string "city"
      t.date "closing_date"
      t.string "county"
      t.string "county_fips"
      t.string "dpv_code"
      t.string "dpv_footnote"
      t.boolean "maestro", default: true
      t.string "overridden_unit_number"
      t.string "plus4_code"
      t.string "postdirection"
      t.string "predirection"
      t.string "primary_number"
      t.string "raw_street_name"
      t.string "raw_unit_number"
      t.float "read_only_downstream_lat"
      t.float "read_only_downstream_lon"
      t.integer "smarty_streets_id"
      t.string "standardized_address"
      t.string "state"
      t.string "street_name"
      t.string "street_suffix"
      t.boolean "success", default: false
      t.string "timezone_name"
      t.integer "timezone_offset"
      t.string "unit_designator"
      t.string "unit_number"
      t.string "zipcode"

      t.timestamps
    end
  end
end

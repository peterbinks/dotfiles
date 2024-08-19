class CreatePortalBrightPolicies < ActiveRecord::Migration[6.1]
  def change
    create_table :bright_policies do |t|
      t.uuid "aggregate_root_id"
      t.integer "billing_method_id"
      t.string "billing_method_type"
      t.string "bind_category"
      t.bigint "coverage_id"
      t.bigint "coverage_version_id"
      t.bigint "custom_quote_id"
      t.datetime "deleted_at"
      t.integer "frozen_insurance_score"
      t.bigint "frozen_rating_id"
      t.string "full_policy_number"
      t.string "inspection_type", default: "none"
      t.string "payment_schedule"
      t.string "payment_type"
      t.string "policy_number_prefix"
      t.integer "policy_number_suffix"
      t.bigint "product_id"
      t.bigint "property_id"
      t.bigint "property_version_id"
      t.bigint "renewal_flag_set_by_id"
      t.string "renewal_status"
      t.string "status"
      t.integer "term", default: 0

      t.timestamps
    end
  end
end

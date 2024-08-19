# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_08_19_165358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "portal_addresses", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "portal_bright_policies", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "portal_documents", force: :cascade do |t|
    t.string "display_name_override"
    t.integer "docset_id"
    t.integer "documentable_id"
    t.string "documentable_type"
    t.string "label"
    t.bigint "person_id"
    t.string "review_status", default: "not_reviewed"
    t.string "reviewed_by"
    t.boolean "show_in_portal", default: false
    t.string "signature"
    t.datetime "signed_at"
    t.string "status", default: "complete"
    t.integer "term", default: 0
    t.bigint "uploaded_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "portal_people", force: :cascade do |t|
    t.integer "address_id"
    t.datetime "banned_at"
    t.text "banned_reason"
    t.integer "created_by_id"
    t.bigint "crm_account_id"
    t.datetime "deleted_at"
    t.date "dob"
    t.string "first_name"
    t.string "kustomer_id"
    t.string "language_preference"
    t.string "last_name"
    t.string "middle_name"
    t.integer "ofac_sanctioned_match_id"
    t.datetime "opt_out_call_at"
    t.datetime "opt_out_email_at"
    t.datetime "opt_out_text_at"
    t.bigint "prior_address_id"
    t.integer "random_number"
    t.datetime "subscriber_agreement_signed_at"
    t.string "suffix"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "portal_phones", force: :cascade do |t|
    t.string "number"
    t.bigint "person_id"
    t.string "phone_type"
    t.boolean "primary", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "portal_users", force: :cascade do |t|
    t.integer "consumed_timestep"
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts"
    t.string "freshsales_id"
    t.string "google_refresh_token"
    t.string "google_token"
    t.boolean "has_visited_funnel", default: false
    t.integer "invalidation_count", default: 0
    t.string "language"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.boolean "otp_required_for_login"
    t.boolean "partner_opt_in", default: false
    t.datetime "remember_created_at"
    t.string "remember_token"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "signing_token_sent_at"
    t.string "unlock_token"
    t.boolean "unsubscribed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end

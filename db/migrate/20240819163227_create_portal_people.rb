class CreatePortalPeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
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
      
      t.timestamps
    end
  end
end

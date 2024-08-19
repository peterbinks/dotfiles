class CreatePortalUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
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

      t.timestamps
    end
  end
end

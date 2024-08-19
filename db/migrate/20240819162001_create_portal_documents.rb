class CreatePortalDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
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

      t.timestamps
    end
  end
end

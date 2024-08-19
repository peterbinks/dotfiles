class CreatePortalPhones < ActiveRecord::Migration[6.1]
  def change
    create_table :phones do |t|
      t.string "number"
      t.bigint "person_id"
      t.string "phone_type"
      t.boolean "primary", default: true

      t.timestamps
    end
  end
end

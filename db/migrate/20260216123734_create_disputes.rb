class CreateDisputes < ActiveRecord::Migration[8.1]
  def change
    create_table :disputes do |t|
      t.references :charge, null: false, foreign_key: true
      t.string :external_id
      t.string :status, null: false, default: "open"
      t.datetime :opened_at
      t.datetime :closed_at
      t.integer :amount_cents, null: false
      t.string :currency, null: false
      t.jsonb :external_payload

      t.timestamps
    end
    add_index :disputes, :external_id, unique: true
    add_index :disputes, :status
  end
end

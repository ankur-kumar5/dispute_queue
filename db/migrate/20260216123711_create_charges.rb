class CreateCharges < ActiveRecord::Migration[8.1]
  def change
    create_table :charges do |t|
      t.string :external_id, null: false
      t.integer :amount_cents, null: false
      t.string :currency, null: false

      t.timestamps
    end
    add_index :charges, :external_id, unique: true
  end
end

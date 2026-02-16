class AddRoleAndTimeZoneToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :string, null: false, default: "read_only"
    add_column :users, :time_zone, :string, default: "UTC"

    add_index :users, :role
  end
end

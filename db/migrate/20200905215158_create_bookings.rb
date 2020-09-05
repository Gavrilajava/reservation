class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :table_id
      t.datetime :time
      t.string :name
      t.integer :persons

      t.timestamps null: false
    end
  end
end

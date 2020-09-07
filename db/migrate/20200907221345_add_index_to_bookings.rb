class AddIndexToBookings < ActiveRecord::Migration
  def change
    add_index :bookings, :table_id
  end
end

class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.integer :number
      t.integer :capacity

      t.timestamps null: false
    end
  end
end

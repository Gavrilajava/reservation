require 'rails_helper'

RSpec.describe Table, type: :model do
  describe 'create and validate' do
    it "is valid with valid attributes" do
      expect(Table.new(number: 1, capacity: 4)).to be_valid
    end
    it "is not valid without a number" do
      expect(Table.new(capacity: 4)).to_not be_valid
    end
    it "is not valid without a capacity" do
      expect(Table.new(number: 1)).to_not be_valid
    end
    it "is not valid with non unique number" do
      table1 = Table.create(number: 1, capacity: 4)
      table2 = Table.new(number: 1, capacity: 4)
      expect(table2).to_not be_valid
    end
  end
  describe '.free' do
    it "return free tables for the time" do
      Table.create(number: 1, capacity: 4)
      Table.create(number: 2, capacity: 4)
      time = (Time.now + 7.days).beginning_of_hour
      Booking.create(table: Table.create(number: 3, capacity: 4), name: "John Doe", persons: 4, time: time)
      expect(Table.free(time).count).to match(2)
    end
  end
  after(:each) do
    Table.destroy_all
  end
end

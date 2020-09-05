require 'rails_helper'

RSpec.describe Booking, type: :model do
  before(:each) do
    @table = Table.create(number: 1, capacity: 4)
    @valid_params = {
      table: @table, 
      name: "John Doe", 
      persons: 4, 
      time: DateTime.parse("2020-09-05 10:00:00")
    }
  end
  describe 'create and validate' do
    it "is valid with valid attributes" do
      expect(Booking.new(@valid_params)).to be_valid
    end
    it "is not valid without a table" do
      expect(Booking.new(@valid_params.except(:table))).to_not be_valid
    end
    it "is not valid without a name" do
      expect(Booking.new(@valid_params.except(:name))).to_not be_valid
    end
    it "is not valid without a persons" do
      expect(Booking.new(@valid_params.except(:persons))).to_not be_valid
    end
    it "is not valid without a time" do
      expect(Booking.new(@valid_params.except(:time))).to_not be_valid
    end
    it "it is not possible to book a table twice" do
      res1 = Item.create(@valid_params)
      res2 = Item.new(@valid_params)
      expect(res2).to_not be_valid
    end
  end
  describe '.book' do
    it "create a Booking when tables are available" do
      Table.create(number: 1, capacity: 4)
      Table.create(number: 2, capacity: 4)
      Booking.book(@valid_params.except(:table))
      expect(Booking.last.name).to match(@valid_params[:name])
    end
    it "returns nil when tables are not available" do
      expect(Booking.book(@valid_params.except(:table))).to match(nil)
    end
    it "books optimal number of tables" do
      Table.create(number: 1, capacity: 5)
      Table.create(number: 2, capacity: 3)
      Table.create(number: 3, capacity: 3)
      Table.create(number: 4, capacity: 2)
      Table.create(number: 4, capacity: 2)
      Table.create(number: 4, capacity: 2)
      @valid_params[:persons] = 6
      Booking.book(@valid_params.except(:table))
      expect(Reservation.count).to match(2)
    end
  end
  after(:each) do
    Table.destroy_all
    Booking.destroy_all
  end
end

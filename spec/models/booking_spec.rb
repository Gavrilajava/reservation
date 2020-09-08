require 'rails_helper'

RSpec.describe Booking, type: :model do
  before(:each) do
    @table = Table.create(number: 1, capacity: 4)
    @valid_params = {
      table: @table, 
      name: "John Doe", 
      persons: 4, 
      time: (Time.now + 7.days).beginning_of_hour
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
      res1 = Booking.create(@valid_params)
      res2 = Booking.new(@valid_params)
      expect(res2).to_not be_valid
    end
    it "should start from the begining of an hour" do
      non_valid_params = @valid_params.except(:time)
      non_valid_params[:time] = DateTime.parse("2020-09-05 10:15:00")
      expect(Booking.new(non_valid_params)).to_not be_valid
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
      Table.destroy_all
      expect(Booking.book(@valid_params.except(:table))).to have_key(:error)
    end
    it "books optimal number of tables" do
      Table.create(number: 1, capacity: 5)
      Table.create(number: 2, capacity: 3)
      Table.create(number: 3, capacity: 3)
      Table.create(number: 4, capacity: 2)
      Table.create(number: 5, capacity: 2)
      Table.create(number: 6, capacity: 2)
      @valid_params[:persons] = 6
      Booking.book(@valid_params.except(:table))
      expect(Booking.count).to match(2)
    end
    it "be able to host an introvert party" do
      Table.destroy_all
      n = 0
      100.times do
        n+= 1
        Table.create(number: n, capacity: 1)
      end
      @valid_params[:persons] = 99
      Booking.book(@valid_params.except(:table))
      expect(Booking.count).to match(99)
    end
    it "be able to manage 10 tables" do
      Table.destroy_all
      n = 0
      10.times do
        n+= 1
        Table.create(number: n, capacity: rand(2...8))
      end
      @valid_params[:persons] = rand(1...16)
      Booking.book(@valid_params.except(:table))
      expect(Booking.sum(:persons)).to match(@valid_params[:persons])
    end
  end
  after(:each) do
    Table.destroy_all
  end
end

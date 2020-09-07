require "rails_helper"

RSpec.describe 'bookings/index', type: :feature do

  before do
    Booking.create(table: Table.create(number: 1, capacity: 4), name: "John Doe", persons: 4, time: DateTime.parse("2020-09-05 10:00:00"))
    Booking.create(table: Table.create(number: 2, capacity: 4), name: "John Doe2", persons: 4, time: DateTime.parse("2020-09-05 10:00:00"))
    Booking.create(table: Table.create(number: 3, capacity: 4), name: "John Doe3", persons: 4, time: DateTime.parse("2020-09-05 10:00:00"))
    visit bookings_path
  end

  it 'renders a list of bookings' do
    expect(all('tbody > tr').size).to eq(3)
  end

  it 'renders bookings form' do
    form = find('form')
    expect(form.find('input#booking_name')[:name]).to eq('booking[name]')
    expect(form.find('input#booking_persons')[:name]).to eq('booking[persons]')
    expect(form.find('input#booking_time')[:name]).to eq('booking[time]')
  end

  after do
    Table.destroy_all
    Booking.destroy_all
  end

end


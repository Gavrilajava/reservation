require 'rails_helper'

RSpec.describe BookingsController, type: :controller do

  describe 'GET index' do
    it 'renders the index action successfully' do
      get :index
      expect(response).to have_http_status :success
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      before do
        table = Table.create(number: 1, capacity: 4)
        booking = {
          name: "John Doe", 
          persons: 4, 
          time: DateTime.parse("2020-09-05 10:00:00")
        }
        post :create, booking: booking
      end

      it 'creates a new booking' do
        expect(Booking.count).to eq 1
      end

      it 'sets notice' do
        expect(flash[:info]).to eq('Table succesfully booked.')
      end
      it 'redirects to index page' do
        expect(response).to redirect_to bookings_path
      end
    end
    describe 'with invalid params' do
      before do
        table = Table.create(number: 1, capacity: 4)
        booking = {
          persons: 4, 
          time: DateTime.parse("2020-09-05 10:00:00")
        }
        post :create, booking: booking
      end

      it 'don\'t create a new booking' do
        expect(Booking.count).to eq 0
      end

      it 'sets errors' do
        expect(flash[:alert]).to_not eq nil
      end
      it 'redirects to index page' do
        expect(response).to redirect_to bookings_path
      end
    end
  end

  describe 'DELETE destroy' do

    before do
      table = Table.create(number: 1, capacity: 4)
      valid_params = {
        table: table, 
        name: "John Doe", 
        persons: 4, 
        time: DateTime.parse("2020-09-05 10:00:00")
      }
      booking = Booking.create(valid_params)
      delete :destroy, id: booking.id
    end

    it 'destroys the requested table' do
      expect(Booking.count).to eq 0
    end

    it 'redirects to the tables list' do
      expect(response).to redirect_to bookings_path
    end

  end

  after(:each) do
    Table.destroy_all
    Booking.destroy_all
  end
end

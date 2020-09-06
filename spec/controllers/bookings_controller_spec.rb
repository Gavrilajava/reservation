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
        Table.create(number: 1, capacity: 4)
        post :create, params: { name: "John Doe", 
                                persons: 4, 
                                time: DateTime.parse("2020-09-05 10:00:00")
                              }
      end

      it 'creates a new booking' do
        expect(Booking.count).to eq 1
      end

      it 'sets notice' do
        expect(flash[:notice]).to eq('Table was succesfully booked.')
      end

      it 'redirects to index page' do
        expect(response).to redirect_to bookings_path
      end
    end
  end

  describe 'DELETE destroy' do
    describe 'with valid params' do
      let(:booking) {
        params = {name: "John Doe", persons: 4, time: DateTime.parse("2020-09-05 10:00:00")}
        table = Table.create(number: 1, capacity: 4)
        table.bookings.create!(params)
      }
      before do
        params[:id] = booking.id
        delete :destroy, params: { id: booking.id}
      end

      it 'deletes the requested item' do
        expect(Booking.find(params[:id])).to eq nil
      end

      it 'redirects to index page' do
        expect(response).to redirect_to bookings_path
      end
    end
  end

  after(:each) do
    Table.destroy_all
  end
end

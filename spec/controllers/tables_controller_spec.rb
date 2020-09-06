require 'rails_helper'

RSpec.describe TablesController, type: :controller do

  describe 'GET index' do
    it 'renders the index action successfully' do
      get :index
      expect(response).to have_http_status :success
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      before do
        post :create, params: { number: 1, capacity: 4} 
      end

      it 'creates a new table' do
        expect(Table.count).to eq 1
      end

      it 'sets notice' do
        expect(flash[:notice]).to eq('Table was succesfully created.')
      end

      it 'redirects to index page' do
        expect(response).to redirect_to tables_path
      end
    end
  end

  describe 'DELETE destroy' do
    describe 'with valid params' do
      let(:table) {
        Table.create(number: 1, capacity: 4)
      }
      before do
        @id = table.id
        delete :destroy, params: { id: table.id}
      end

      it 'deletes the requested item' do
        expect(Booking.find(@id)).to eq nil
      end

      it 'redirects to index page' do
        expect(response).to redirect_to tables_path
      end
    end
  end

  after(:each) do
    Table.destroy_all
  end
end

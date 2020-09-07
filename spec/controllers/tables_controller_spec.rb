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
        post :create, table: {number: 1, capacity: 4}
      end

      it 'creates a new table' do
        expect(Table.count).to eq 1
      end

      it 'sets notice' do
        expect(flash[:info]).to eq('Table succesfully created.')
      end
      it 'redirects to index page' do
        expect(response).to redirect_to tables_path
      end
    end
    describe 'with invalid params' do
      before do
        post :create, table: {number: 1}
      end

      it 'don\'t create a new table' do
        expect(Table.count).to eq 0
      end

      it 'sets errors' do
        expect(flash[:alert]).to_not eq nil
      end
      it 'redirects to index page' do
        expect(response).to redirect_to tables_path
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      table = Table.create(number: 1, capacity: 4)
      delete :destroy, id: table.id
    end

    it 'destroys the requested table' do
      expect(Table.count).to eq 0
    end

    it 'redirects to to index page' do
      expect(response).to redirect_to tables_path
    end

  end

  after(:each) do
    Table.destroy_all
  end
end

RSpec.describe 'tables/index', type: :feature do

  before do
    Table.create(number: 1, capacity: 4)
    Table.create(number: 2, capacity: 4)
    Table.create(number: 3, capacity: 4)
    Table.create(number: 4, capacity: 4)
    Table.create(number: 5, capacity: 4)
    visit tables_path
  end

  it 'renders a list of tables' do
    expect(all('tbody > tr').size).to eq(5)
  end

  it 'renders tables form' do
    visit tables_path
    form = find('form.new_table')
    expect(form.find('input#table_number')[:name]).to eq('table[number]')
    expect(form.find('input#table_capacity')[:name]).to eq('table[capacity]')
  end

  after do
    Table.destroy_all
  end

end


class Booking < ActiveRecord::Base

  validates :table, :name, :persons, :time, presence: true
  validates :time, uniqueness: {scope: :table}
  validate :should_start_from_beginning_of_an_hour

  belongs_to :table

  def should_start_from_beginning_of_an_hour
    if time && time.min != 0
      errors.add(:time, "should start from beginning of an hour")
    end
  end

  # function to get all possible tables combination for group
  # tables are sorted by capacity, so if tables capacity without a smallest(first)
  # less than pesrons, it can be added. 
  # Finally, the change problem has come in useful in life.
  def self.get_all_tables_combinations(tables, persons)
    if tables.last(tables.length - 1).sum < persons
      result = [tables]
    else 
      result = []
    end
    tables.each_with_index{ |table, index| 
      less_tables = tables.first(index) + tables.last(tables.length - 1 - index)
      if less_tables.sum >= persons
        result = (result + Booking.get_all_tables_combinations(less_tables, persons)).uniq
      end
    }
    result
  end

  # function to get best possible tables combination for group of people
  # it is also checks total capacity and if there is a single table that fits the group
  def self.get_best_tables_combination(tables, persons)
    if tables.sum < persons
      nil
    else
      if tables.find{|t| t == persons}
        [persons]
      else
        combinations = Booking.get_all_tables_combinations(tables, persons)
        min_seats = combinations.min_by{ |t| t.sum }.sum
        combinations = combinations.filter{ |c| c.sum == min_seats}
        combinations.min_by{ |t| t.length }
      end
    end
  end

  # method to book the table/tables for the group of people
  # it return an array of integers in case of success and hash with key :error in case of failure
  def self.book(params)
    tables = Booking.get_best_tables_combination(Table.free(params[:time]).pluck(:capacity), params[:persons])
    if tables
      begin
        persons = params[:persons]
        tables.each{ |c|
          table = Table.free(params[:time]).find{ |t|  t.capacity == c}
          Booking.create(
            table_id: table.id, 
            name: params[:name], 
            persons: [persons, table.capacity].min, 
            time: params[:time]
          )
          persons -= table.capacity
        }
      rescue StandardError => e
        {error: e}
      end
    else
      {error: "No tables available at this time"}
    end
  end
end

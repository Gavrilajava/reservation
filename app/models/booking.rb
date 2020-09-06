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

  def self.get_all_tables_combinations(tables, persons)
    result = [tables]
    tables.each_with_index{ |table, index| 
      less_tables = tables.first(index) + tables.last(tables.length - 1 - index)
      if less_tables.sum >= persons
        result = (result + Booking.get_all_tables_combinations(less_tables, persons)).uniq
      end
    }
    result
  end

  def self.get_best_tables_combination(tables, persons)
    if tables.sum < persons
      nil
    else
      combinations = Booking.get_all_tables_combinations(tables, persons)
      min_seats = combinations.min_by{ |t| t.sum }.sum
      combinations = combinations.filter{ |c| c.sum == min_seats}
      combinations.min_by{ |t| t.length }
    end
  end

  def self.book(params)
    tables = Booking.get_best_tables_combination(Table.free(params[:time]).pluck(:capacity), params[:persons])
    if tables
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
    else
      nil
    end
  end
end

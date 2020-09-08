class Booking < ActiveRecord::Base

  validates :table, :name, :persons, :time, presence: true
  validates :time, uniqueness: {scope: :table}
  validates :time, inclusion: {
                                in: (Time.now..Date.today+1.years), 
                                message: "should not be in the past or more than a year from now"
                              }
  validate :should_start_from_beginning_of_an_hour

  belongs_to :table

  scope :ordered, -> { includes(:table).order(:time) }

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
      raise "No tables available at this time"
    else
      if tables.find{|t| t == persons}
        [persons]
      else
        combinations = Booking.get_all_tables_combinations(tables, persons)
        min_seats = combinations.min_by{ |t| t.sum }.sum
        combinations = combinations.select{ |c| c.sum == min_seats}
        combinations.min_by{ |t| t.length }
      end
    end
  end

  # method to book the table/tables for the group of people
  # it return an hash with key :error in case of failure
  # and key notice
  def self.book(params)
    begin
      tables = Booking.get_best_tables_combination(Table.capacity(params[:time]), params[:persons].to_i)
      persons = params[:persons].to_i
      tables.each{ |c|
        table = Table.pick(params[:time], c)
        booking = Booking.create(
          table_id: table.id,
          name: params[:name],
          persons: [persons, table.capacity].min,
          time: params[:time]
        )
        if booking.valid?
          persons -= table.capacity
        else
          raise booking.error_messages
        end
      }
      { notice: "#{'Table'.pluralize(tables.count)} succesfully booked." }
    rescue StandardError => e
      { error: e.message }
    end
  end

  def error_messages
    self.errors.messages.map{ |key, value| "Booking #{key} #{value.join(', ')}" }.join(', ')
  end
end

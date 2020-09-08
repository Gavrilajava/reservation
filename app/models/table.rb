class Table < ActiveRecord::Base

  validates :number, presence: true, uniqueness: true
  validates :capacity, presence: true, numericality: {greater_than: 0}

  has_many :bookings

  scope :occupied, -> (time){ includes(:bookings).where(bookings: { time: time.to_datetime }).pluck(:id) }
  scope :free, -> (time){ where.not(id: occupied(time)).order(:capacity).pluck(:id) }
  scope :capacity, -> (time){ where(id: free(time)).pluck(:capacity) }
  scope :pick, -> (time, capacity){ where(id: free(time)).find_by(capacity: capacity) }
  scope :ordered, -> { order(:number) }


  def error_messages
    self.errors.messages.map{ |key, value| "Table #{key} #{value.join(', ')}" }.join(', ')
  end

end

class Table < ActiveRecord::Base

  validates :number, presence: true, uniqueness: true
  validates :capacity, presence: true, numericality: {only_integer: true, greater_than: 0}

  has_many :bookings, dependent: :destroy

  scope :occupied, -> (time){ includes(:bookings).where(bookings: { time: time.to_datetime }).pluck(:id) }
  scope :free, -> (time){ where.not(id: occupied(time)).pluck(:id) }
  scope :capacity, -> (time){ where(id: free(time)).order(:capacity).pluck(:capacity) }
  scope :pick, -> (time, capacity){ where(id: free(time)).find_by(capacity: capacity) }
  scope :ordered, -> { order(:number) }


  # method to stringify validation errors
  def error_messages
    self.errors.messages.map{ |key, value| "Table #{key} #{value.join(', ')}" }.join(', ')
  end

end

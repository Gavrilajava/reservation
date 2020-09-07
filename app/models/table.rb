class Table < ActiveRecord::Base

  validates :number, presence: true, uniqueness: true
  validates :capacity, presence: true

  has_many :bookings

  scope :occupied, -> (time){ includes(:bookings).where(bookings: { time: time.to_datetime }) }
  scope :free, -> (time){ where.not(id: occupied(time).pluck(:id)).order(:capacity) }
  scope :capacity, -> (time){ where(id: free(time).pluck(:id)).pluck(:capacity)}
  scope :pick, -> (time, capacity){where(id: free(time).pluck(:id)).find_by(capacity: capacity)}

  def error_messages
    self.errors.messages.map{ |key, value| "Table #{key} #{value.join(',')}" }.join(',')
  end

end

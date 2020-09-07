class Table < ActiveRecord::Base

  validates :number, presence: true, uniqueness: true
  validates :capacity, presence: true
  
  has_many :bookings

  scope :occupied, -> (time){ includes(:bookings).where(bookings: { time: time }) }
  scope :free, ->(time){ where.not(id: occupied(time).pluck(:id)).order(:capacity) }

  def error_messages
    self.errors.messages.map{ |key, value| "Table #{key} #{value.join(',')}" }.join(',')
  end
  
end

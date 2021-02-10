class Sale < ActiveRecord::Base
  validates :starts_on, :ends_on, presence: true
  validate :end_date_after_start_date

  # AR Scope
  # scope :active, => {where(.....)}
  def self.active
    where('sales.starts_on <= ? AND sales.ends_on >= ?', Date.current, Date.current)
  end

  def finished?
    ends_on < Date.current
  end

  def upcomming?
    starts_on > Date.current
  end

  def active?
    !upcomming? && !finished?
  end

  private

  def end_date_after_start_date
    if ends_on < starts_on
      errors.add(:ends_on, 'must be after the start date')
    elsif starts_on < Date.current
      errors.add(:starts_on, 'must be a future date')
    end
end
end

class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource

  before_validation do |b|
    status ||= 'pending'
  end

  validates :status, inclusion: {in: %w(pending approved)}
  validates :user, :resource, :start_time, :end_time, :status, presence: true

  validate :end_cannot_be_before_start

  validate :cannot_make_reservation_in_the_past, on: :create

  def end_cannot_be_before_start
    if end_time && start_time && (end_time < start_time)
      errors.add(:end_time, "End_time can't be younger than start_time")
    end
  end

  def cannot_make_reservation_in_the_past
    if start_time && (start_time < DateTime.now)
      errors.add(:start_time, "Cant start in the past")
    end
  end
end

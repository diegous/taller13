#gem 'validates_email_format_of'
# te permite usar  :email_format

class User < ActiveRecord::Base
  validates_email_format_of :email
  validates :email, :username, :uniqueness => true, presence: true

  has_many :bookings
  has_many :resources, through: :bookings
end

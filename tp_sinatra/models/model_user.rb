#gem 'validates_email_format_of'
# te permite usar  :email_format
class User < ActiveRecord::Base
  validates :email,
            :email_format,
            :uniqueness => true, 
             presence: true

  has_many :bookings
  has_many :resources, through: :bookings
end

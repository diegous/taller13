class User < ActiveRecord::Base
  validates :email, 
            :uniqueness => true, 
             presence: true

  has_many :bookings
  has_many :resources, through: :bookings
end
=begin -- gem 'validates_email_format_of' y le mandas :email_format
=end

class Booking < ActiveRecord::Base
  validates :start, :status, presence: true
  
  belongs_to :users
  belongs_to :resources
end

class Resource < ActiveRecord::Base
  validates :name, :description, presence: true

  has_many :bookings
  has_many :users, through: :bookings
end

class Booking < ActiveRecord::Base
  acts_as_referred referrer_field: :referrer
end

module ActsAsReferred
  extend ActiveSupport::Concern
  
  included do
  end
       
  module ClassMethods
    def acts_as_referred(options = {})
      cattr_accessor :referrer_field
      self.referrer_field = (options[:referrer_field] || :referred_from).to_s

      include ActsAsReferred::InstanceMethods
    end
  end

  module InstanceMethods
    def referrer_host
      URI.parse(self.send(self.referrer_field)).host
    end
  end

end

ActiveRecord::Base.send :include, ActsAsReferred

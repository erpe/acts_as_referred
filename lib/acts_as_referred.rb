module ActsAsReferred
  extend ActiveSupport::Concern
  
  included do
  end
       
  module ClassMethods
    def acts_as_referred(options = {})
      cattr_accessor :referrer_field
      self.referrer_field = (options[:referrer_field] || :referred_from).to_s
      
      before_create :fill_referrer_field

      include ActsAsReferred::InstanceMethods
    end
    
  end

  module InstanceMethods
    
    def referrer_uri
      has_referrer? ? URI.parse(self.send(self.referrer_field)) : nil
    end

    def referrer_host
      has_referrer? ? URI.parse(self.send(self.referrer_field)).host : nil
    end

    def referrer_scheme
      has_referrer? ? URI.parse(self.send(self.referrer_field)).scheme : nil
    end

    def referrer_query
      has_referrer? ? URI.parse(self.send(self.referrer_field)).query : nil
    end

    def referrer_path
      has_referrer? ? URI.parse(self.send(self.referrer_field)).path : nil
    end

    def has_referrer?
      true if self.send(self.referrer_field)
    end

    private

    def fill_referrer_field
      self.send("#{self.referrer_field}=", "fooobar")
    end
  end

end

ActiveRecord::Base.send :include, ActsAsReferred

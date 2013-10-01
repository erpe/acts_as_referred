module ActsAsReferred
  module ClassMethods
  
    # Hook to serve behavior to ActiveRecord-Descendants
    def acts_as_referred(options = {})
      
      has_one :referee, as: :referable, dependent: :destroy, class_name: 'Referee'
      after_create :create_referrer

      include ActsAsReferred::InstanceMethods
    end
    
  end
end

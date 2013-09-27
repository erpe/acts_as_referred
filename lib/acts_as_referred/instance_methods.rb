module ActsAsReferred
  module InstanceMethods
    
    delegate :campaign, to: :referee 

    private

    def create_referrer
      self.create_referee(raw: _get_referrer ) if _get_referrer
    end
  end
end

module ActsAsReferred
  module InstanceMethods
    
    private

    # after create hook to create a corresponding +Referee+
    def create_referrer
      
      # will not respond to _get_reqref unless 
      # reqref injected in application-controller
      #
      if self.respond_to?(:_get_reqref)
        if struct = _get_reqref

          self.create_referee(
                      origin: struct.referrer_url, 
                      request: struct.request_url, 
                      visits: struct.visit_count
                      )
        end
      end
    end

  end
end


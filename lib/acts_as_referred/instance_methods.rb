module ActsAsReferred
  module InstanceMethods
    
    private

    def create_referrer
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


module ActsAsReferred
  module InstanceMethods
    
    private

    def create_referrer
      _origin = _get_referrer if _get_referrer
      _request = _get_request if _get_request
      _utm = cookies['__utmz']
      if _origin || _request
        self.create_referee(origin: _origin, request: _request, utmz: _utm ) 
      end
    end

  end
end

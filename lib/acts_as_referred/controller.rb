module ActsAsReferred
  
  module Controller
    extend ActiveSupport::Concern

    included do
      before_filter :_store_session
    end

    protected

    def _store_session

      if _request = instance_variable_get(:@_request)
        unless _request.session.has_key?(:_origin)
          _request.session[:_origin] = _request.referrer
        end
      end

      ActiveRecord::Base.send(:define_method, '_get_referrer', proc { _request.session[:_origin]} )
    end
    
  end
end

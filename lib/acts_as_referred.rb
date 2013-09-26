module ActsAsReferred
  extend ActiveSupport::Concern
  
  included do
  end

  module Model
    class ::Referee < ActiveRecord::Base
      self.table_name = 'referees'

      # fields: campaign, 
      #attr_reader :host, :scheme, :path, :query

      belongs_to :referable, polymorphic: true 

      before_create :process_referred_from
      
      def uri
        has_referrer? ? URI.parse(referred_from) : nil
      end

      def host
        has_referrer? ? URI.parse(referred_from).host : nil
      end

      def scheme
        has_referrer? ? URI.parse(referred_from).scheme : nil
      end

      def query
        has_referrer? ? URI.parse(referred_from).query : nil
      end

      def path
        has_referrer? ? URI.parse(referred_from).path : nil
      end

      def has_referrer?
        true if referred_from
      end

      private

      def process_referred_from

      end
    end
  end

  module ControllerMethods
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
       
  module ClassMethods
    def acts_as_referred(options = {})
      
      has_one :referee, as: :referable, dependent: :destroy, class_name: 'Referee'
      after_create :create_referrer

      include ActsAsReferred::InstanceMethods
    end
    
  end

  module InstanceMethods
    
    

    private

    def create_referrer
      self.create_referee(referred_from: _get_referrer ) if _get_referrer
    end
  end

end

ActiveRecord::Base.send :include, ActsAsReferred

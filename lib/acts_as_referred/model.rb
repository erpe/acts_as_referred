module ActsAsReferred
  
  module Model
    class ::Referee < ActiveRecord::Base
      self.table_name = 'referees'

      # fields: campaign, 
      #attr_reader :host, :scheme, :path, :query

      belongs_to :referable, polymorphic: true 

      before_create :process_referred_from
      
      def uri
        has_referrer? ? URI.parse(raw) : nil
      end

      def host
        has_referrer? ? URI.parse(raw).host : nil
      end

      def scheme
        has_referrer? ? URI.parse(raw).scheme : nil
      end

      def query
        has_referrer? ? URI.parse(raw).query : nil
      end

      def path
        has_referrer? ? URI.parse(raw).path : nil
      end

      def has_referrer?
        true if raw
      end

      private

      def process_referred_from

      end
    end
  end

end

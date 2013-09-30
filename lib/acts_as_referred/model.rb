module ActsAsReferred
  
  module Model

    # Represents a Referee - 
    # *attributes*
    # origin:: the full URI of referrer
    # path:: the requested path
    # query:: the query-string - e.g. ?pk_campaign=terror&pk_kwd=usa
    # campaign:: the supplied campaign-name in query
    # keywords:: the supplied keywords in query
    # source:: e.g. by utm_source 'newsletter'
    # utmz:: google cpc cookie
    # is_campaign:: if this referee is from campaign
    # is_organic:: if this referee is by organic search
    # is_natural:: if this referee is direct
    #
    class ::Referee < ActiveRecord::Base
      self.table_name = 'referees'

      belongs_to :referable, polymorphic: true 

      before_create :process_request_and_referrer

      # referrer - returns URI
      #
      def origin_uri
        has_referrer? ? URI.parse(origin) : nil
      end
      
      # referrer - returns host part 
      #
      def host
        has_referrer? ? URI.parse(origin).host : nil
      end

      # request - returns path
      #
      def path
        has_request? ? URI.parse(request).path : nil
      end
      

      def has_referrer?
        true if origin
      end

      def has_request?
        true if request
      end

      private

      # 1. referring-host        e.g: google.com/search?q=tracking+gem
      # 2. request.query_string  
      # 2.1. from campaign:
      # 2.2. organic
      # 2.3. 

      def process_request_and_referrer
        process_request if request  
        process_origin if origin
        process_utmz if utmz
      end

      def process_request
        query = URI.parse(request).query
        case query
        when =~ /pwk_campaign/
        when =~ // 
      end

      def process_origin
        origin_host = URI.parse(origin).host
      end

    end

  end

end

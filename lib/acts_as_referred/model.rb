module ActsAsReferred
  
  module Model

    # Represents a Referee - 
    # *attributes*
    # origin:: the full URI of referrer
    # origin_host:: dns-name of referrer
    # request:: the request
    # request_query:: the query-string - may be nil
    # campaign:: the supplied campaign-name in query
    # keywords:: the supplied keywords in query
    # is_campaign:: if this referee is from campaign
    # is_organic:: if this referee is by organic search
    # is_natural:: if this referee is direct
    #
    class ::Referee < ActiveRecord::Base
      self.table_name = 'referees'

      belongs_to :referable, polymorphic: true 

      before_create :process_request_and_referrer

      scope :campaigns, -> { where('is_campaign=?', true) }

      # referrer - returns URI
      #
      def origin_uri
        has_referrer? ? URI.parse(origin) : nil
      end
      
      # referrer - returns host part 
      #
      def host
        origin_host
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

      def has_query?
        true if URI.parse(request).query
      end

      private

      def process_request_and_referrer
        process_origin if origin
        
        if request && URI.parse(request).query
          self.request_query = URI.parse(request).query
          if process_request
            self.is_campaign = true
          end
        end
      end

      def process_request
        if self.request_query
          if self.request_query.match(/utm_campaign/) || self.request_query.match(/utm_term/)
            return process_google_tagged(self.request_query)
          end
          if self.request_query.match(/pk_campaign/) || self.request_query.match(/pk_term/)
            return process_piwik_tagged(self.request_query)
          end
          if self.request_query.match(/gclid/)
            return process_google_auto_tagged(self.request_query)
          end
        end
      end

      
      # we only care about campaign name and keywords
      #
      def process_google_tagged(string)
        hash = Hash[* string.split('&').collect { |i| i.split('=') }.flatten]
        retval = nil
        hash.keys.each do |key|
          case key
          #when 'utm_source'
          #  source = hash[key]
          when 'utm_campaign'
            self.campaign = hash[key]
            retval = true
          #when 'utm_medium'
          #  medium = hash[key]
          when 'utm_term'
            self.keywords = hash[key]
            retval = true
          end
        end
        retval
      end

      def process_piwik_tagged(string)
        hash = Hash[*(string.split('&').collect { |i| i.split('=') }.flatten)]
        retval = nil
        hash.keys.each do |key|
          case key
          when 'pk_campaign'
            self.campaign = hash[key]
            retval = true
          when 'pk_kwd'
            self.keywords = hash[key]
            retval = true
          end
        end
        retval
      end

      # adwords set to autotagging
      # no chance to get campaign info by url
      # would have to do cookie parsing - this sucks
      #
      def process_google_auto_tagged(string)
        hash = Hash[* string.split('|').collect { |i| i.split('=') }.flatten]
        retval = nil
        if hash['gclid']
          self.campaign = "Adwords - autotagged: #{hash['gclid']}"
          self.is_campaign = true
          retval = true
        end
        retval
      end
      
      def process_origin
        self.origin_host = URI.parse(origin).host
      end

    end

  end

end

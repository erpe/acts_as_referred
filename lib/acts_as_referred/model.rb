module ActsAsReferred

  # Namespace for ActsAsReferred-model
  module Model

    # Represents a Referee - 
    # *attributes*
    # [origin]        the full URI of referrer
    # [origin_host]   host-part of referrer
    # [request]       the full request as string
    # [request_query] the query-string - may be nil
    # [campaign]      the supplied campaign-name in query
    # [keywords]      the supplied keywords in query
    # [is_campaign]   if this referee is from campaign
    # [visits]        number of visits before conversion
    #
    class ::Referee < ActiveRecord::Base
      
      self.table_name = 'referees'

      belongs_to :referable, polymorphic: true

      before_create :process_request_and_referrer

      # all referees which where created throughout a 
      # campaign-based request
      scope :campaigns, -> { where('is_campaign=?', true) }

      # returns referrer as instance of URI
      def origin_uri
        has_referrer? ? URI.parse(origin) : nil
      end
      
      # returns host-part of referrer  
      # may be nil
      def host
        origin_host
      end

      # returns path part of request
      # may be nil
      def request_path
        URI.parse(request).path
      end
      
      def has_referrer?
        true if origin
      end

      def has_request?
        true if request
      end

      def has_query?
        true if request_query
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

      
      # a.t.m. only care about campaign name and keywords
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
      
      # standard piwik campaign-tracking
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
      # would have to do cookie parsing - what would suck
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

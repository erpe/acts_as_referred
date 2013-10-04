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

      # tags as used by google or piwik in campaign-tracking
      TAGS = {  
                campaign: %w{ pk_campaign utm_campaign gclid },
                keyword: %w{ pk_kwd utm_term}
              }

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
          TAGS.values.flatten.each do |word| 
            if self.request_query.match(word)
              return process_tagged
            end
          end
        end
      end

      # a.t.m. only care about campaign name and keywords
      def process_tagged
        hash = splatten_hash
        retval = nil
        TAGS.keys.each do |key|
          TAGS[key].each do |x|
            if key == :campaign && hash[x]
              self.campaign = hash[x] if self.campaign.nil? || self.campaign.empty?
              retval = true
            elsif key == :keyword && hash[x]
              self.keywords = hash[x] if self.keywords.nil? || self.keywords.empty?
              retval = true 
            end
          end
        end
        retval
      end
      
      def splatten_hash
        Hash[*(self.request_query.split('&').collect { |i| i.split('=') }.flatten)]
      end

      def process_origin
        self.origin_host = URI.parse(origin).host
      end

    end

  end

end

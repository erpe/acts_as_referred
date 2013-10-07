module ActsAsReferred
 
  # Namespce for controller-related functionality
  module Controller
    extend ActiveSupport::Concern

    included do
      before_filter :_check_cookie_and_session
      before_filter :_supply_model_hook
    end

    protected
    
    # The before_filter which processes necessary data for 
    # +acts_as_referred+ - models
    def _supply_model_hook

      # 3.2.1 -> adwords auto-tagging - (show hint to manual tag adwords):
      #  ?gclid=xxxx   
      # 3.2.2 -> manual tagging 
      #  ?utm_source=google&utm_medium=cpc&utm_term=my_keyword&utm_campaign=my_summerdeal  
      # 3.2.3 -> manual url-tagging specific for piwik 
      #  ?pk_campaign=my_summerdeal&pk_kwd=my_keyword  
      # cookie / session persisted:
      # e.g.: "req=http://foo/baz?utm_campaign=plonk|ref=http://google.com/search|count=0"
      
      tmp = session[:__reqref]
      _struct = nil
      if tmp
        arr = tmp.split('|')
        _struct = OpenStruct.new(
                    request_url: arr[0].split('=',2)[1],
                    referrer_url: minlength_or_nil(arr[1].split('=',2)[1]),
                    visit_count: arr[2].split('=',2)[1].to_i
                    )
      end

      ActiveRecord::Base.send(
                              :define_method, 
                              '_get_reqref', 
                              proc{ _struct }   
                             )
    end


    private

    # checks for existing +__reqref+ key in session
    # if not found checks for signed cookie with key +__reqref+
    # if this is the initial request to our site, we write a cookie with 
    # referrer and request.url
    def _check_cookie_and_session
      if session[:__reqref]
        tmp = session[:__reqref]
      else
        if cookies.signed[:__reqref]
          tmp = cookies.signed[:__reqref]
          tmp = _increment_returning_count(tmp)
          _set_cookie(__reqref: tmp)
        else
          tmp = "req=#{request.url}|ref=#{request.referrer}|ret=0"
          _set_cookie(__reqref: tmp)
        end
        session[:__reqref] = tmp
      end
    end

    def _set_cookie(args={})
      args.each_pair do |k,v|
        cookies.signed[k] = { value: v, expires: 1.month.from_now }
      end
    end

    def _increment_returning_count(tmp)
      arr = tmp.split('|')
      arr[-1] = "ret=#{arr[-1].split('=')[-1].to_i + 1}"
      arr.join('|')
    end

    def minlength_or_nil(string)
      URI.parse(string).host ? string : nil
    end
    
  end

end

module ActsAsReferred
  
  module Controller
    extend ActiveSupport::Concern

    included do
      before_filter :_check_cookie_and_session
      before_filter :_supply_model_hook
    end

    protected

    def _supply_model_hook

      # 1. check ob wir ein cookie gesetzt haben mit angaben zu referrer
      #
      # 2. nimm referrer und wirf ihn in den struct
      # 2.1 rippe referrer_host und wirf ihn ins model
      # 
      # 3. nimm request_fullpath und wirf ihn in den struct
      # 3.1 nimm fullpath und exzerpiere: query
      # 3.2. suche nach matches für:
      # 3.2.1 -> adwords auto-tagging - (show hint to manual tag adwords):
      #             ?gclid=xxxx   
      # 3.2.2 -> manual tagging 
      #             ?utm_source=google&utm_medium=cpc&utm_term=my_keyword&utm_campaign=my_summerdeal  
      # 3.2.3 -> manual url-tagging specific for piwik 
      #             ?pk_campaign=my_summerdeal&pk_kwd=my_keyword  
      #

      # origin - referrer
      # request - full-request

      ActiveRecord::Base.send(
                              :define_method, 
                              '_get_reqref', 
                              proc { _process_struct } 
                             )
    end


    

    private 

    def _process_struct
      tmp = session[:__reqref]
      if tmp
        arr = tmp.split('|')
        OpenStruct.new(
              request_url: arr[0].split('=')[-1],
              referrer_url: arr[1].split('=')[-1],
              visit_count: arr[2].split('=')[-1].to_i
              )
      end
    end

    def _check_cookie_and_session
      args = {}
      if session[:__reqref]
        tmp = session[:__reqref]
      else
        if cookies.signed[:__reqref]
          tmp = cookies.signed[:__reqref]
          tmp = _increment_returning_count(tmp)
          _set_cookie(__reqref: tmp)
        else
          tmp = "req=#{request.uri}|ref=#{request.referrer}|ret=0"
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
      arr = tmp.split("|")
      arr[-1] = "ret=#{arr[-1].split('=')[-1].to_i + 1}"
      arr.join('|')
    end
    
  end

end

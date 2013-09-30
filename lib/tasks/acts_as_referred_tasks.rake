namespace :acts_as_referred do
  
  desc "This will setup a database-table 'referees'"
  task :create_table do
    args =  %w{ referable_id:integer:index 
                referable_type:string:index 
                is_campaign:boolean:index
                is_organic:boolean:index
                is_natural:boolean:index
                origin:string
                origin_host:string
                request:string 
                request_query:string
                utmz:string
                campaign:string 
                keywords:string
                source:string
                          
    }
    system("bundle exec rails g migration CreateReferee #{args.join(' ')}")
  end

end

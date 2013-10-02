namespace :acts_as_referred do
  
  desc "This will setup a database-table 'referees'"
  task :create_table do
    args =  %w{ referable_id:integer:index 
                referable_type:string:index 
                is_campaign:boolean:index
                origin:text
                origin_host:string
                request:text 
                request_query:string
                campaign:string 
                keywords:string
                visits:integer
                          
    }
    system("bundle exec rails g migration CreateReferee #{args.join(' ')}")
  end

end

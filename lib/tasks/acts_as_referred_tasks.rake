namespace :acts_as_referred do
  
  desc "This will setup a database-table 'referees'"
  task :create_table do
    args =  %w{ referable_id:integer:index 
                referable_type:string:index 
                is_campaign:boolean:index
                origin:text
                origin_host:string
                request:text 
                request_query:text
                campaign:string 
                keywords:string
                visits:integer
                created_at:datetime
                updated_at:datetime
    }
    system("bundle exec rails g migration CreateReferee #{args.join(' ')}")
  end

  desc "add timestamps when migrating from prior 0.1.3"
  task :add_timestamps do
    args = %w{ created_at:datetime updated_at:datetime }
    system("bundle exec rails g migration AddTimestampsToReferee #{args.join(' ')}")
  end

end

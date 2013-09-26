namespace :acts_as_referred do
  
  desc "This will setup a database-table 'referees'"
  task :create_table do
    args =  %w{ referable_id:integer:index 
                referable_type:string:index 
                raw:string 
                campaign:string 
                keywords:string 
              }
    system("bundle exec rails g migration CreateReferee #{args.join(' ')}")
  end

end

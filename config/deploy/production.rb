role :app, appserver_production
role :web, appserver_production
role :db,  appserver_production, :primary => true

set :branch, "production"
set :rails_env, "production"

task :set_staging_flag, :roles => [:app] do
end
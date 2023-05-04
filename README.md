# Getting Started in development
./docker/build_and_tag.sh
./docker/start_app.sh

In a new pane
./docker/exec_db.sh
psql -Upostgres
psql -Upostgres
CREATE USER dumbledore login createdb;
\password dumbdledore
  <dumbledore_development>

In a new pane
./docker/exec.sh
bundle exec rake db:create
RAILS_ENV=development bin/rails db:migrate 
RAILS_ENV=development bundle exec rake schedule:ingest
RAILS_ENV=development bundle exec rake rankings:update
RAILS_ENV=development bundle exec rake advocate:import_schedule[spec/download_fixtures/advocate/schedule_3_31.html] 
RAILS_ENV=test bundle exec rspec

# ToDo
- Silo JS and CSS files between apps
- move wrestling stats to subdirectory

# Creating a new app "new_application"
- new sub directories in 
  - /models
  - /controllers 
  - /views
  - /views/layouts
- new ApplicationController with layout in new controller dir
- generate new nested models
  - RAILS_ENV=development bundle exec rails g NewApplication::Drinks oz:integer abv:integer
  - this will also add a models/new_application.rb module with the table prefix
- add a new controller in new_application
- add namespaced route in config/routes
- add a new view in /views/new_application/controller/index.html.erb
- Can now visit in browser


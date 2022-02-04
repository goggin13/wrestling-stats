git push
git push heroku main
heroku run rake db:migrate
heroku run rake rankings:update
heroku run rake schedule:ingest

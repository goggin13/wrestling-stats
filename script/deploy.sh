git push
git push heroku main
heroku run rake db:migrate
heroku run rake rankings:update

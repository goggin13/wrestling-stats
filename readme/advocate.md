### Advocate PreProd

#ToDo
[X] Make schedule browser work for RNs
[ ] Review all code, sanity check test coverage, rm unused code
[X] Add people on orientation
[ ] Add techs

Output:
[X] Histogram of staffing %s
[X] Current Staffing table (todo: changes from last month)
[ ] Add techs to all the above

password protect
deploy
monitoring/alerting for dumbledore
automate download or else it can never be prod

# Tasks

### Import a schedule
RAILS_ENV=development bundle exec rake advocate:import_schedule[spec/download_fixtures/advocate/schedule_6_26.html]

### Rebuild everything from spec/download_fixtures/advocate/archive
RAILS_ENV=development bundle exec rake advocate:rebuild


Questions: 
spec/download_fixtures/advocate/schedule.html
Unknown codes:
OC19-12
[EXTRA]
[$]
[FL]
[SWTC]

## Pre Meeting
* Download last month to current day of data productive only (AH Daily Roster by Time)
  * 2023-09_ah_daily_productive_only.csv
* Download last month to current day of data non productive (AH Daily Roster by Time)
  * 2023-09_ah_daily_nonproductive.csv
* RAILS_ENV=development bin/rails advocate:import_schedule[advocate_data/csv/2023-09_ah_daily_productive_only.csv]
* RAILS_ENV=development bin/rails advocate:import_orientees[advocate_data/csv/2023-09_ah_daily_nonproductive.csv]
* git commit -am "updated data pre-staff meeting" && git push

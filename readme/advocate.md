### Advocate PreProd

#ToDo
[ ] Make schedule browser work for RNs
[ ] Review all code, sanity check test coverage, rm unused code
[ ] Add people on orientation
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

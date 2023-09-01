### Advocate PreProd

#ToDo
[ ] CONFIRM w/NICOLE THAT THESE SCHEDULES EVEN WORK
[ ] Establish goals
[ ] Pull all the historical data
[ ] Don't hardcode names for triage, charge, preceptor
  [ ] Assign hours based on employees normal shift times
[ ] Parsing runs with more verbose output to nail down unknowns

Output:
[X] Histogram of staffing %s
[ ] Stacked Bar chart of hours by Staff vs Agency
[X] Current Staffing table (todo: changes from last month)
[ ] Trendline of staffing numbers, Agcy, FTEmployee
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

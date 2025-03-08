class RawSchedule
  def self.ingest
    Wrestler.destroy_all
    College.destroy_all
    Match.destroy_all

    colleges.each do |data|
      college = College.find_or_create_by_corrected_name(data[0])
      college.update!(url: data[1])
    end

    matches.each do |data|
      away_team = College.find_or_create_by_corrected_name(data[2])
      home_team = College.find_or_create_by_corrected_name(data[3])

      time = data[1]
      watch_on = data[4]
      date = Date.strptime(data[0], "%m/%d/%Y")
      params = {away_team: away_team, home_team: home_team, date: date}

      params.merge!(time: time) if time.present?
      params.merge!(watch_on: watch_on) if watch_on.present?

      Match.create!(params)
    end
  end

  def self.matches
    MATCHES
  end

  def self.colleges
    COLLEGES
  end

	COLLEGES = [
		['Penn State', 'https://gopsusports.com/sports/wrestling/schedule'],
		['Iowa', 'https://hawkeyesports.com/sports/wrestling/schedule/'],
		['Michigan', 'https://mgoblue.com/sports/wrestling/schedule'],
		['Nebraska', 'https://huskers.com/sports/wrestling/schedule'],
		['Wisconsin', 'https://uwbadgers.com/sports/wrestling/schedule'],
		['Minnesota', 'https://gophersports.com/sports/wrestling/schedule'],
		['Ohio State', 'https://ohiostatebuckeyes.com/sports/wrestling/schedule'],
		['Northwestern', 'https://nusports.com/sports/wrestling/schedule'],
		['Purdue', 'https://purduesports.com/sports/wrestling/schedule'],
		['Cornell', 'https://cornellbigred.com/sports/wrestling/schedule'],
		['Virginia Tech', 'https://hokiesports.com/sports/wrestling/schedule'],
		['Iowa State', 'https://cyclones.com/sports/wrestling/schedule'],
		['Missouri', 'https://mutigers.com/sports/wrestling/schedule'],
		['Stanford', 'https://gostanford.com/sports/wrestling/schedule'],
		['NC State', 'https://gopack.com/sports/wrestling/schedule'],
		['Arizona State', 'https://thesundevils.com/sports/wrestling/schedule'],
		['Oklahoma State', 'https://okstate.com/sports/wrestling/schedule'],
		['Penn', 'https://pennathletics.com/sports/wrestling/schedule'],
		['Lehigh', 'https://lehighsports.com/sports/wrestling/schedule'],
		['Princeton', 'https://goprincetontigers.com/sports/wrestling/schedule'],
	]

  MATCHES = [
    ['11/15/2024', '20:00', 'Utah Valley', 'Oklahoma State', 'Flo'],
    ['11/17/2024', '16:00', 'Oregon State', 'Oklahoma State', 'Flo'],
    ['11/22/2024', '19:00', 'Wyoming', 'Oklahoma State', 'ESPN+'],
    ['11/24/2024', '13:00', 'Arizona State', 'Oklahoma State', 'ESPN+'],
    ['12/13/2024', '19:00', 'Oklahoma', 'Oklahoma State', 'ESPN+'],
    ['12/19/2024', '19:00', 'Virginia Tech', 'Oklahoma State', 'ESPN+'],
    ['1/3/2025', '19:00', 'Air Force', 'Oklahoma State', 'ESPN+'],
    ['1/12/2025', '14:00', 'NC State', 'Oklahoma State', 'ESPN+'],
    ['1/19/2025', '14:00', 'West Virginia', 'Oklahoma State', 'ESPN+'],
    ['1/24/2025', '19:00', 'Northern Iowa', 'Oklahoma State', 'Flo'],
    ['1/26/2025', '14:00', 'Iowa State', 'Oklahoma State', ''],
    ['2/2/2025', '14:00', 'Missouri', 'Oklahoma State', 'ESPN+'],
    ['2/8/2025', '19:00', 'Little Rock', 'Oklahoma State', 'UFC Fight Pass'],
    ['2/23/2025', '19:30', 'Iowa', 'Oklahoma State', 'B1G'],
    ['11/23/2024', '18:00', 'Iowa State', 'Iowa', 'ESPN+'],
    ['12/6/2024', '18:00', 'Princeton', 'Iowa', 'UFC Fight Pass'],
    ['12/6/2024', '20:00', 'Army', 'Iowa', 'UFC Fight Pass'],
    ['1/12/2025', '14:00', 'Wisconsin', 'Iowa', 'B1G+'],
    ['1/17/2025', '18:00', 'Illinois', 'Iowa', 'B1G'],
    ['1/25/2025', '13:00', 'Ohio State', 'Iowa', 'B1G'],
    ['1/31/2025', '18:00', 'Penn State', 'Iowa', 'B1G'],
    ['2/2/2025', '13:00', 'Maryland', 'Iowa', 'B1G+'],
    ['2/7/2025', '19:00', 'Nebraska', 'Iowa', 'B1G'],
    ['2/14/2025', '20:00', 'Minnesota', 'Iowa', 'B1G'],
    ['2/16/2025', '13:00', 'Northwestern', 'Iowa', 'B1G+'],
    ['11/17/2024', '12:00', 'Drexel', 'Penn State', 'B1G+'],
    ['12/8/2024', '13:00', 'Lehigh', 'Penn State', 'Flo'],
    ['12/15/2024', '12:00', 'Wyoming', 'Penn State', 'B1G+'],
    ['12/22/2024', '15:00', 'Binghampton', 'Penn State', 'Rokfin'],
    ['12/22/2024', '17:00', 'Arkansas', 'Penn State', 'Rokfin'],
    ['12/22/2024', '19:00', 'Missouri', 'Penn State', 'Rokfin'],
    ['1/10/2025', '19:00', 'Michigan State', 'Penn State', 'B1G'],
    ['1/17/2025', '20:00', 'Nebraska', 'Penn State', 'B1G'],
    ['1/24/2025', '19:00', 'Rutgers', 'Penn State', 'B1G'],
    ['2/7/2025', '17:00', 'Michigan', 'Penn State', 'B1G'],
    ['2/9/2025', '13:00', 'Maryland', 'Penn State', 'B1G'],
    ['2/14/2025', '18:00', 'Ohio State', 'Penn State', 'B1G'],
    ['2/16/2025', '13:00', 'Illionois', 'Penn State', 'B1G+'],
    ['2/21/2025', '18:00', 'American', 'Penn State', 'B1G+'],
    ['11/17/2024', '16:00', 'Columbia', 'Michigan', 'B1G+'],
    ['11/22/2024', '18:00', 'Duke', 'Michigan', ''],
    ['11/24/2024', '18:00', 'Virginia', 'Michigan', ''],
    ['1/10/2025', '17:00', 'Maryland', 'Michigan', 'B1G'],
    ['1/17/2025', '19:00', 'Northwestern', 'Michigan', 'B1G+'],
    ['1/19/2025', '13:00', 'Minnesota', 'Michigan', 'B1G+'],
    ['1/24/2025', '17:00', 'Nebraska', 'Michigan', 'B1G'],
    ['1/26/2025', '13:00', 'Indiana', 'Michigan', 'B1G+'],
    ['2/1/2025', '13:00', 'Ohio State', 'Michigan', 'B1G'],
    ['2/16/2025', '11:00', 'Michigan State', 'Michigan', 'B1G'],
    ['2/23/2025', '', 'Central Michigan', 'Michigan', 'B1G+'],
    ['11/15/2024', '15:30', 'Campbell', 'Nebraska', 'UFC Fight Pass'],
    ['11/15/2024', '19:00', 'North Carolina', 'Nebraska', ''],
    ['1/5/2025', '13:00', 'Northern Iowa', 'Nebraska', ''],
    ['1/11/2025', '15:30', 'Minnesota', 'Nebraska', 'B1G'],
    ['1/26/2025', '12:00', 'Michigan State', 'Nebraska', 'B1G'],
    ['1/31/2025', '18:00', 'Wisconsin', 'Nebraska', 'B1G'],
    ['2/16/2025', '12:30', 'Indiana', 'Nebraska', 'B1G'],
    ['2/23/2025', '17:30', 'Purdue', 'Nebraska', 'B1G'],
    ['11/17/2024', '13:00', 'Edinboro', 'Ohio State', 'Flo'],
    ['11/24/2024', '11:00', 'Hofstra', 'Ohio State', 'B1G+'],
    ['12/13/2024', '18:00', 'Pittsburgh', 'Ohio State', ''],
    ['1/5/2025', '12:00', 'Oregon State', 'Ohio State', 'B1G+'],
    ['1/10/2025', '', 'Illinois', 'Ohio State', 'B1G+'],
    ['1/12/2025', '17:00', 'Rutgers', 'Ohio State', 'B1G'],
    ['1/19/2025', '12:00', 'Purdue', 'Ohio State', 'B1G+'],
    ['2/7/2025', '18:00', 'Minnesota', 'Ohio State', 'B1G+'],
    ['2/9/2025', '13:00', 'Indiana', 'Ohio State', 'B1G+'],
    ['11/15/2024', '18:00', 'Missouri', 'Virginia Tech', 'ESPN+'],
    ['11/22/2024', '18:00', 'Rutgers', 'Virginia Tech', 'ESPN+'],
    ['1/10/2025', '18:00', 'North Carolina', 'Virginia Tech', 'ESPN+'],
    ['1/19/2025', '18:00', 'App State', 'Virginia Tech', ''],
    ['1/24/2025', '18:00', 'Duke', 'Virginia Tech', 'ESPN+'],
    ['1/31/2025', '18:00', 'Virginia', 'Virginia Tech', 'ESPN+'],
    ['2/7/2025', '18:00', 'Stanford', 'Virginia Tech', ''],
    ['2/14/2025', '18:00', 'Pittsburgh', 'Virginia Tech', 'ESPN+'],
    ['2/21/2025', '18:00', 'NC State', 'Virginia Tech', 'ESPN+'],
    ['11/15/2024', '18:00', 'App State', 'NC State', 'ESPN+'],
    ['11/17/2024', '13:00', 'Princeton', 'NC State', 'UFC Fight Pass'],
    ['11/17/2024', '15:00', 'Rutgers', 'NC State', 'UFC Fight Pass'],
    ['11/23/2024', '18:00', 'Utah Valley', 'NC State', ''],
    ['12/22/2024', '15:00', 'Cornell', 'NC State', ''],
    ['1/10/2025', '18:00', 'Duke', 'NC State', ''],
    ['1/17/2025', '18:00', 'Virginia', 'NC State', ''],
    ['1/24/2025', '18:00', 'Pittsburgh', 'NC State', ''],
    ['1/31/2025', '18:00', 'North Carolina', 'NC State', ''],
    ['2/14/2025', '18:00', 'Stanford', 'NC State', ''],
    ['11/15/2024', '19:00', 'Bucknell', 'Minnesota', 'B1G+'],
    ['11/22/2024', '18:00', 'North Dakota State', 'Minnesota', ''],
    ['11/24/2024', '13:00', 'Campbell', 'Minnesota', 'B1G+'],
    ['12/1/2024', '14:00', 'South Dakota State', 'Minnesota', ''],
    ['1/24/2025', '19:00', 'Wisconsin', 'Minnesota', 'B1G+'],
    ['1/26/2025', '', 'Northwestern', 'Minnesota', 'B1G'],
    ['2/2/2025', '12:00', 'Rutgers', 'Minnesota', 'B1G'],
    ['2/9/2025', '12:00', 'Purdue', 'Minnesota', 'B1G+'],
    ['11/15/2024', '19:00', 'Navy', 'Iowa State', 'ESPN+'],
    ['12/15/2024', '14:00', 'North Dakota State', 'Iowa State', 'Flo'],
    ['12/21/2024', '', 'Lock Haven', 'Iowa State', 'Varsity Network'],
    ['12/21/2024', '', 'North Carolina', 'Iowa State', 'Varsity Network'],
    ['12/21/2024', '', 'Ohio State', 'Iowa State', 'Varsity Network'],
    ['1/8/2025', '', 'West Virginia', 'Iowa State', 'ESPN+'],
    ['1/11/2025', '11:00', 'Rider', 'Iowa State', 'Varsity Network'],
    ['1/11/2025', '14:00', 'Bucknell', 'Iowa State', 'Varsity Network'],
    ['1/24/2025', '19:00', 'Oklahoma', 'Iowa State', 'ESPN+'],
    ['2/9/2025', '13:00', 'Arizona State', 'Iowa State', 'ESPN+'],
    ['2/14/2025', '19:00', 'South Dakota State', 'Iowa State', 'Varsity Network'],
    ['2/16/2025', '13:00', 'Northern Iowa', 'Iowa State', 'Flo'],
    ['2/22/2025', '12:00', 'Missouri', 'Iowa State', 'UFC Fight Pass'],
    ['11/26/2024', '19:00', 'South Dakota State', 'Northern Iowa', ''],
    ['11/26/2024', '19:00', 'Missouri', 'Northern Iowa', ''],
    ['1/17/2025', '19:00', 'Arizona State', 'Northern Iowa', ''],
    ['1/25/2025', '18:00', 'Oklahoma', 'Northern Iowa', ''],
    ['2/1/2025', '19:00', 'West Virginia', 'Northern Iowa', ''],
    ['2/8/2025', '19:00', 'North Dakota State', 'Northern Iowa', ''],
    ['2/21/2025', '19:00', 'Wisconsin', 'Northern Iowa', ''],
    ['11/23/2024', '12:00', 'Buffalo', 'Cornell', 'ESPN+'],
    ['1/3/2025', '17:00', 'Missouri', 'Cornell', ''],
    ['1/12/2025', '11:00', 'Lehigh', 'Cornell', 'ESPN+'],
    ['1/25/2025', '11:00', 'Harvard', 'Cornell', 'ESPN+'],
    ['1/25/2025', '16:30', 'Brown', 'Cornell', 'ESPN+'],
    ['2/1/2025', '13:00', 'Binghampton', 'Cornell', 'ESPN+'],
    ['2/2/2025', '11:00', 'Columbia', 'Cornell', 'ESPN+'],
    ['2/8/2025', '12:00', 'Princeton', 'Cornell', 'ESPN+'],
    ['2/9/2025', '12:00', 'Penn', 'Cornell', 'ESPN+'],
    ['2/15/2025', '', 'Arizona State', 'Cornell', ''],
    ['2/22/2025', '14:00', 'Bucknell', 'Cornell', 'ESPN+'],

    ['12/06/2024', '14:00', 'Illinois', 'Indiana', 'ESPN+'],
    ['12/06/2024', '14:00', 'Rutgers', 'Lock Haven', 'ESPN+'],
  ]
end

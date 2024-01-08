class RawSchedule
  def self.ingest
    Wrestler.destroy_all
    College.destroy_all
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

      match = Match.find_by(away_team: away_team, home_team: home_team)
      if match.present?
        match.update!(params)
      else
        Match.create!(params)
      end
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
		['12/3/2023', '13:00', 'Lehigh', 'Penn State', ''],
		['12/10/2023', '12:00', 'Hofstra', 'Penn State', 'B1G+'],
		['1/5/2024', '19:00', 'Penn State', 'Oregon State', 'Pac 12 Network'],
		['1/14/2024', '12:00', 'Indiana', 'Penn State', 'B1G+'],
		['1/19/2024', '17:00', 'Penn State', 'Michigan', 'B1G'],
		['1/21/2024', '12:00', 'Penn State', 'Michigan State', 'B1G'],
		['1/28/2024', '11:00', 'Penn State', 'Maryland', 'B1G'],
		['2/2/2024', '17:30', 'Ohio State', 'Penn State', 'B1G'],
		['2/9/2024', '20:00', 'Penn State', 'Iowa', 'B1G'],
		['2/12/2024', '18:00', 'Rutgers', 'Penn State', 'B1G'],
		['2/18/2024', '15:00', 'Nebraska', 'Penn State', 'B1G'],
		['2/25/2024', '13:00', 'Edinboro', 'Penn State', 'B1G+'],
		['11/18/2023', '12:00', 'Oregon State', 'Iowa', 'B1G+'],
		['11/26/2023', '14:00', 'Iowa', 'Iowa State', 'ESPN'],
		['12/1/2023', '18:00', 'Iowa', 'Penn', 'ESPN+'],
		['12/8/2023', '19:00', 'Columbia', 'Iowa', 'B1G+'],
		['1/12/2024', '18:00', 'Iowa', 'Nebraska', 'B1G'],
		['1/15/2024', '19:00', 'Minnesota', 'Iowa', 'B1G'],
		['1/19/2024', '19:00', 'Purdue', 'Iowa', 'B1G'],
		['1/26/2024', '20:00', 'Iowa', 'Illinois', 'B1G'],
		['1/28/2024', '14:00', 'Iowa', 'Northwestern', ''],
		['2/2/2024', '19:30', 'Iowa', 'Michigan', 'B1G'],
		['2/18/2024', '13:00', 'Wisconsin', 'Iowa', 'B1G'],
		['2/25/2024', '14:00', 'Iowa', 'Oklahoma State', 'FS1'],
		['11/17/2023', '18:00', 'Michigan', 'Columba', 'ESPN+'],
		['11/19/2023', '13:00', 'Michigan', 'Rider', 'ESPN+'],
		['1/4/2024', '19:00', 'South Dakota State', 'Michigan', ''],
		['1/12/2024', '18:00', 'Maryland', 'Michigan', ''],
		['1/14/2024', '13:00', 'Michigan State', 'Michigan', ''],
		['1/21/2024', '12:00', 'Rutgers', 'Michigan', ''],
		['1/26/2024', '18:00', 'Michigan', 'Ohio State', 'B1G'],
		['2/9/2024', '18:00', 'Michigan', 'Nebraska', ''],
		['2/16/2024', '12:00', 'Michigan', 'Indiana', ''],
		['2/25/2024', '13:00', 'Michigan', 'Central Michigan', ''],
		['11/18/2023', '09:00', 'Nebraska', 'Navy', 'Flo'],
		['12/16/2023', '18:00', 'South Dakota State', 'Nebraska', 'B1G+'],
		['1/6/2024', '14:00', 'Wyoming', 'Nebraska', 'B1G+'],
		['1/6/2024', '16:00', 'Northern Iowa', 'Nebraska', 'B1G+'],
		['1/19/2024', '21:00', 'Nebraska', 'Minnesota', 'B1G'],
		['1/21/2024', '13:00', 'Purdue', 'Nebraska', 'B1G+'],
		['1/26/2024', '19:00', 'Nebraska', 'Northwestern', 'B1G+'],
		['1/28/2024', '13:00', 'Nebraska', 'Wisconsin', 'B1G'],
		['2/4/2024', '14:00', 'Nebraska', 'Illinois', 'B1G+'],
		['2/25/2024', '12:00', 'Nebraska', 'Arizona State', ''],
		['11/19/2023', '14:00', 'Iowa State', 'Wisconsin', 'UFC'],
		['12/3/2023', '13:00', 'Bucknell', 'Wisconsin', 'B1G+'],
		['12/9/2023', '11:00', 'Wisconsin', 'Rider', ''],
		['12/9/2023', '17:00', 'Wisconsin', 'Drexel', ''],
		['1/21/2024', '14:00', 'Ohio State', 'Wisconsin', 'B1G'],
		['1/26/2024', '01:00', 'Wisconsin', 'Michigan State', 'B1G+'],
		['2/2/2024', '19:00', 'Northwestern', 'Wisconsin', 'B1G+'],
		['2/4/2024', '12:00', 'Wisconsin', 'Purdue', 'B1G+'],
		['2/11/2024', '12:00', 'Illinois', 'Wisconsin', 'B1G'],
		['2/16/2024', '20:00', 'Wisconsin', 'Minnesota', 'B1G'],
		['2/25/2024', '13:00', 'Wisconsin', 'Northern Iowa', ''],
		['11/16/2023', '18:00', 'Minnesota', 'Bucknell', 'ESPN+'],
		['11/26/2023', '12:00', 'South Dakota State', 'Minnesota', 'B1G+'],
		['12/2/2023', '01:00', 'Minnesota', 'SIU Edwardsville', ''],
		['12/10/2023', '14:00', 'North Dakota State', 'Minnesota', 'B1G+'],
		['1/27/2024', '12:00', 'Minnesota', 'Rutgers', 'B1G'],
		['2/2/2024', '19:00', 'Maryland', 'Minnesota', 'B1G'],
		['2/4/2024', '13:00', 'Northwestern', 'Minnesota', 'B1G'],
		['2/9/2024', '01:00', 'Minnesota', 'Illinois', 'B1G'],
		['2/11/2024', '12:00', 'Minnesota', 'Purdue', 'B1G'],
		['11/19/2023', '10:00', 'Ohio State', 'Columbia', 'ESPN+'],
		['11/19/2023', '15:00', 'Ohio State', 'Hofstra', ''],
		['12/10/2023', '11:00', 'Ohio State', 'Pittsburgh', 'B1G'],
		['1/5/2024', '19:00', 'Cornell', 'Ohio State', 'B1G'],
		['1/12/2024', '18:00', 'Illinois', 'Ohio State', 'B1G+'],
		['1/19/2024', '18:00', 'Maryland', 'Ohio State', 'B1G+'],
		['2/4/2024', '12:00', 'Ohio State', 'Rutgers', 'B1G+'],
		['2/11/2024', '11:00', 'Indiana', 'Ohio State', 'B1G+'],
		['2/16/2024', '18:00', 'Ohio State', 'Michigan State', 'B1G'],
		['2/19/2023', '12:30', 'Northwestern', 'Northern Illinois', ''],
		['1/14/2024', '13:00', 'Northwestern', 'Maryland', ''],
		['1/20/2024', '14:00', 'Northwestern', 'Illinois', ''],
		['2/9/2024', '19:00', 'Purdue', 'Northwestern', ''],
		['2/16/2024', '19:00', 'Binghamton', 'Northwestern', ''],
		['2/18/2024', '14:00', 'Indiana', 'Northwestern', ''],
		['2/19/2023', '09:00', 'Purdue', 'Campbell University', ''],
		['2/19/2023', '11:00', 'Stanford', 'Purdue', ''],
		['2/19/2023', '13:00', 'Purdue', 'North Dakota State', ''],
		['1/14/2024', '12:00', 'Rutgers', 'Purdue', ''],
		['1/27/2024', '01:00', 'Purdue', 'Indiana', ''],
		['2/16/2024', '18:00', 'Illinois', 'Purdue', ''],
		['11/18/2023', '11:00', 'Cornell', 'Sacred Heart', 'ESPN+'],
		['1/7/2024', '01:00', 'Virginia Tech', 'Cornell', 'ESPN+'],
		['1/13/2024', '12:00', 'Cornell', 'Lehigh', ''],
		['1/27/2024', '01:00', 'Brown', 'Cornell', 'ESPN+'],
		['1/27/2024', '02:00', 'Harvard', 'Cornell', 'ESPN+'],
		['1/28/2024', '12:00', 'Missouri', 'Cornell', 'ESPN+'],
		['2/3/2024', '12:00', 'Columbia', 'Cornell', 'ESPN+'],
		['2/9/2024', '18:30', 'Cornell', 'Princeton', 'ESPN+'],
		['2/10/2024', '18:00', 'Cornell', 'Penn', 'ESPN+'],
		['2/16/2024', '01:00', 'Cornell', 'NC State', 'ESPN+'],
		['2/18/2024', '01:00', 'Cornell', 'Appalachian State', ''],
		['2/25/2024', '12:00', 'Binghamton', 'Cornell', 'ESPN+'],
		['12/17/2023', '12:00', 'Stanford', 'Virginia Tech', ''],
		['1/2/2024', '18:00', 'Virginia Tech', 'Missouri', ''],
		['1/7/2024', '01:00', 'Virginia Tech', 'Cornell', ''],
		['1/12/2024', '18:00', 'Appalachian State', 'Virginia Tech', ''],
		['1/26/2024', '18:00', 'North Carolina', 'Virginia Tech', ''],
		['2/2/2024', '18:00', 'Virginia Tech', 'Virginia', ''],
		['2/9/2024', '18:00', 'Duke', 'Virginia Tech', ''],
		['2/10/2024', '14:00', 'George Mason', 'Virginia Tech', ''],
		['2/16/2024', '18:00', 'Virginia Tech', 'Pittsburgh', ''],
		['2/23/2024', '18:00', 'Virginia Tech', 'NC State', ''],
		['12/18/2023', '14:00', 'Iowa State', 'Pittsburgh', 'Rokfin'],
		['12/18/2023', '16:00', 'Iowa State', 'Little Rock', 'Rokfin'],
		['12/18/2023', '18:00', 'Iowa State', 'Cornell', 'Rokfin'],
		['12/18/2023', '14:00', 'Cornell', 'Little Rock', 'Rokfin'],
		['12/18/2023', '16:00', 'Cornell', 'Pittsburgh', 'Rokfin'],
		['1/6/2024', '01:00', 'Iowa State', 'Arizona State', ''],
		['1/14/2024', '14:00', 'Pittsburgh', 'Iowa State', 'ESPN+'],
		['1/26/2024', '19:00', 'Iowa State', 'Oklahoma', ''],
		['1/27/2024', '18:00', 'Iowa State', 'Oklahoma State', ''],
		['2/2/2024', '19:00', 'West Virginia', 'Iowa State', 'ESPN+'],
		['2/11/2024', '14:00', 'Northern Iowa', 'Iowa State', 'ESPN+'],
		['2/25/2024', '14:00', 'Missouri', 'Iowa State', 'ESPN+'],
		['12/1/2023', '19:00', 'Oklahoma', 'Missouri', 'Flow'],
		['12/8/2023', '19:00', 'Wyoming', 'Missouri', 'Flow'],
		['12/17/2023', '13:00', 'Air Force', 'Missouri', 'Flow'],
		['12/21/2023', '19:00', 'Missouri', 'Illinois', ''],
		['1/10/2024', '16:00', 'Missouri', 'Stanford', ''],
		['1/26/2024', '19:00', 'Missouri', 'West Virginia', ''],
		['2/4/2024', '01:00', 'Oklahoma State', 'Missouri', 'Flow'],
		['2/16/2024', '19:00', 'Missouri', 'North Dakota State', ''],
		['2/18/2024', '14:00', 'Missouri', 'South Dakota State', 'Flow'],
		['2/23/2024', '19:00', 'Missouri', 'Northern Iowa', 'Flow'],
		['1/21/2024', '17:00', 'Stanford', 'Penn', ''],
		['2/17/2024', '10:00', 'Stanford', 'Arizona State', ''],
		['2/18/2024', '12:00', 'Oregon State', 'Stanford', ''],
		['12/19/2023', '12:00', 'NC State', 'Lock Haven', 'Rokfin'],
		['12/19/2023', '14:00', 'Ohio State', 'Lock Haven', 'Rokfin'],
		['12/19/2023', '14:00', 'NC State', 'Northern Iowa', 'Rokfin'],
		['12/19/2023', '16:00', 'NC State', 'Ohio State', 'Rokfin'],
		['1/5/2024', '18:00', 'Oklahoma State', 'NC State', 'ESPNU'],
		['1/26/2024', '18:00', 'NC State', 'Pittsburgh', ''],
		['2/2/2024', '19:30', 'NC State', 'North Carolina', ''],
		['2/9/2024', '18:00', 'Virginia', 'NC State', ''],
		['2/18/2024', '13:00', 'NC State', 'Duke', ''],
		['1/21/2024', '01:00', 'Arizona State', 'Pittsburgh', ''],
		['2/2/2024', '01:00', 'Arizona State', 'Oklahoma State', ''],
		['2/4/2024', '12:00', 'Oregon State', 'Arizona State', ''],
		['2/24/2024', '18:00', 'Arizona State', 'Lehigh', ''],
		['12/8/2023', '19:00', 'Lehigh', 'Oklahoma State', ''],
		['12/10/2023', '14:00', 'Oklahoma', 'Oklahoma State', ''],
		['12/19/2023', '19:00', 'Wyoming', 'Oklahoma State', 'Flow'],
		['1/12/2024', '18:00', 'Oklahoma State', 'Pittsburgh', ''],
		['1/14/2024', '12:00', 'West Virginia', 'Oklahoma State', 'ESPN+'],
		['1/21/2024', '14:00', 'Oregon State', 'Oklahoma State', 'ESPN+'],
		['1/26/2024', '19:00', 'Northern Iowa', 'Oklahoma State', 'ESPN+'],
		['2/18/2024', '14:00', 'Oklahoma', 'Oklahoma State', ''],
		['1/6/2024', '18:00', 'Rutgers', 'Penn', 'ESPN+'],
		['1/12/2024', '18:00', 'Penn', 'North Carolina', ''],
		['1/19/2024', '18:00', 'Penn', 'Lehigh', ''],
		['1/28/2024', '12:00', 'Columbia', 'Penn', 'ESPN+'],
		['2/3/2024', '12:00', 'Penn', 'Brown', 'ESPN+'],
		['2/4/2024', '11:00', 'Penn', 'Harvard', 'ESPN+'],
		['2/17/2024', '11:00', 'Penn', 'Princeton', 'ESPN+'],
  ]
end

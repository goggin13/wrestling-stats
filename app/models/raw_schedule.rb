class RawSchedule
  def self.ingest
    colleges.each do |data|
      college = College.find_or_create_by(name: data[0])
      college.update!(url: data[1])
    end

    matches.each do |data|
      away_team = College.find_or_create_by(name: data[2])
      home_team = College.find_or_create_by(name: data[3])

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
    ['Northwestern', 'https://nusports.com/sports/wrestling/schedule'],
    ['Missouri', 'https://mutigers.com/sports/wrestling/schedule'],
    ['Ohio State', 'https://ohiostatebuckeyes.com/sports/m-wrestl/schedule/'],
    ['Arizona State', 'https://thesundevils.com/sports/wrestling/schedule/2022-23'],
    ['Cornell', 'https://cornellbigred.com/sports/wrestling/schedule/2022-23'],
    ['Oklahoma State', 'https://okstate.com/sports/wrestling/schedule/2022-23'],
    ['Michigan', 'https://mgoblue.com/sports/wrestling/schedule/2022-23'],
    ['Minnesota', 'https://gophersports.com/sports/wrestling/schedule/2022-23'],
    ['Nebraska', 'https://huskers.com/sports/wrestling/schedule/2022-23'],
    ['Iowa State', 'https://cyclones.com/sports/wrestling/schedule'],
    ['Stanford', 'https://gostanford.com/sports/wrestling/schedule'],
    ['Wisconsin', 'https://uwbadgers.com/sports/wrestling/schedule'],
    ['Virginia Tech', 'https://hokiesports.com/sports/wrestling/schedule/2022-23'],
    ['NC State', 'https://gopack.com/sports/wrestling/schedule/2022-23'],
    ['Penn', 'https://pennathletics.com/sports/wrestling/schedule/2022-23'],
    ['Princeton', 'https://goprincetontigers.com/sports/wrestling/schedule/2022-23'],
    ['Lehigh', 'https://lehighsports.com/sports/wrestling/schedule'],
 ]

  MATCHES = [
    ['11/11/2022', '18:00', 'Lock Haven', 'Penn State', ''],
    ['12/2/2022', '18:30', 'Penn State', 'Rider', ''],
    ['12/4/2022', '13:00', 'Penn State', 'Lehigh', ''],
    ['12/11/2022', '13:00', 'Oregon State', 'Penn State', ''],
    ['1/6/2023', '20:00', 'Penn State', 'Wisconsin', 'BTN'],
    ['1/20/2023', '18:00', 'Michigan', 'Penn State', ''],
    ['1/22/2023', '12:00', 'Michigan State', 'Penn State', ''],
    ['1/27/2023', '19:30', 'Iowa', 'Penn State', ''],
    ['2/3/2023', '18:00', 'Penn State', 'Ohio State', ''],
    ['2/5/2023', '12:00', 'Penn State', 'Indiana', ''],
    ['2/12/2023', '12:00', 'Maryland', 'Penn State', ''],
    ['2/19/2023', '12:00', 'Clarion', 'Penn State', ''],
    ['11/17/2022', '18:00', 'Iowa', 'Army', ''],
    ['11/18/2022', '17:30', 'Sacred Heart', 'Iowa', ''],
    ['11/18/2022', '19:30', 'Buffalo', 'Iowa', ''],
    ['12/4/2022', '13:30', 'Iowa State', 'Iowa', ''],
    ['12/10/2022', '18:00', 'Iowa', 'Chattanooga', ''],
    ['1/6/2023', '', 'Illinois', 'Iowa', ''],
    ['1/8/2023', '13:00', 'Iowa', 'Purdue', ''],
    ['1/13/2023', '20:00', 'Northwestern', 'Iowa', ''],
    ['1/20/2023', '20:00', 'Nebraska', 'Iowa', ''],
    ['1/22/2023', '', 'Iowa', 'Wisconsin', ''],
    ['2/3/2023', '20:00', 'Iowa', 'Minnesota', ''],
    ['2/10/2023', '20:00', 'Michigan', 'Iowa', ''],
    ['2/19/2023', '15:30', 'Oklahoma State', 'Iowa', ''],
    ['1/7/2023', '14:00', 'Minnesota', 'Northwestern', ''],
    ['1/15/2023', '14:00', 'Northwestern', 'Nebraska', ''],
    ['1/20/2023', '19:00', 'Illinois', 'Northwestern', ''],
    ['1/27/2023', '19:00', 'Wisconsin', 'Northwestern', ''],
    ['1/29/2023', '15:00', 'Northwestern', 'Rutgers', ''],
    ['2/5/2023', '14:00', 'Ohio State', 'Northwestern', ''],
    ['2/12/2023', '11:00', 'Northwestern', 'Purdue', ''],
    ['12/2/2022', '17:30', 'West Virginia', 'Missouri', 'Flow'],
    ['12/11/2022', '19:00', 'Missouri', 'Virginia Tech', ''],
    ['12/20/2022', '18:30', 'North Dakota State', 'Missouri', 'Flow'],
    ['1/8/2023', '', 'Northern Iowa', 'Missouri', 'Flow'],
    ['1/13/2023', '18:30', 'Missouri', 'Air Force', ''],
    ['1/14/2023', '', 'Missouri', 'Wyoming', 'Flow'],
    ['2/3/2023', '', 'Missouri', 'Oklahoma', ''],
    ['2/5/2023', '14:00', 'Missouri', 'Oklahoma State', ''],
    ['2/15/2023', '', 'Iowa State', 'Missouri', 'Flow'],
    ['1/6/2023', '18:00', 'Ohio State', 'Indiana', 'BTN'],
    ['1/15/2023', '12:00', 'Rutgers', 'Ohio State', 'BTN+'],
    ['1/20/2023', '18:00', 'Ohio State', 'Maryland', 'BTN+'],
    ['1/27/2023', '17:00', 'Ohio State', 'Michigan', 'BTN'],
    ['1/29/2023', '12:00', 'Michigan State', 'Ohio State', 'BTN+'],
    ['2/3/2023', '18:00', 'Penn State', 'Ohio State', 'BTN'],
    ['2/5/2023', '14:00', 'Ohio State', 'Northwestern', 'BTN+'],
    ['2/10/2023', '18:00', 'Nebraska', 'Ohio State', 'BTN'],
    ['1/4/2023', '19:00', 'Cornell', 'Arizona State', 'Flow'],
    ['1/8/2023', '15:00', 'Arizona State', 'Iowa State', ''],
    ['1/15/2023', '15:00', 'Princeton', 'Arizona State', ''],
    ['1/20/2023', '20:00', 'Cal Poly', 'Arizona State', ''],
    ['1/22/2023', '14:00', 'Arizona State', 'Stanford', ''],
    ['1/28/2023', '20:00', 'Arizona State', 'Lehigh', ''],
    ['2/5/2023', '20:00', 'Arizona State', 'Oregon State', ''],
    ['2/19/2023', '15:00', 'Arizona State', 'Nebraska', ''],
    ['12/19/2022', '11:00', 'Cornell', 'Oregon State', ''],
    ['12/19/2022', '13:00', 'Cornell', 'Iowa State', ''],
    ['1/6/2023', '18:00', 'Cornell', 'Virginia Tech', 'ESPN+'],
    ['1/14/2023', '17:30', 'Lehigh', 'Cornell', 'ESPN+'],
    ['1/21/2023', '11:00', 'Cornell', 'Brown', 'ESPN+'],
    ['1/21/2023', '17:00', 'Cornell', 'Harvard', 'ESPN+'],
    ['1/28/2023', '13:00', 'Cornell', 'Army West Point', ''],
    ['1/29/2023', '13:00', 'Cornell', 'Columbia', 'ESPN+'],
    ['2/4/2023', '11:00', 'Princeton', 'Cornell', 'ESPN+'],
    ['2/5/2023', '12:00', 'Penn', 'Cornell', 'ESPN+'],
    ['2/10/2023', '18:00', 'Cornell', 'Binghamptom', ''],
    ['2/18/2023', '12:00', 'Cornell', 'Ohio State', ''],
    ['12/4/2022', '14:00', 'Minnesota', 'Oklahoma State', 'ESPN+'],
    ['12/11/2022', '14:00', 'Oklahoma State', 'Oklahoma', 'ESPNU'],
    ['1/8/2023', '14:00', 'Oklahoma State', 'Oregon State', ''],
    ['1/15/2023', '12:00', 'Oklahoma State', 'Columbia', ''],
    ['1/28/2023', '', 'Oklahoma State', 'Northern Iowa', ''],
    ['1/29/2023', '', 'Oklahoma State', 'Iowa State', 'ESPN+'],
    ['2/3/2023', '', 'Michigan', 'Oklahoma State', ''],
    ['2/5/2023', '', 'Missouri', 'Oklahoma State', ''],
    ['2/10/2023', '', 'Oklahoma State', 'South Dakota State', ''],
    ['2/12/2023', '', 'Stanford', 'Oklahoma State', 'ESPN+'],
    ['2/19/2023', '', 'Oklahoma State', 'Iowa', 'BTN'],
    ['1/13/2023', '', 'Michigan', 'Michigan State', ''],
    ['1/15/2023', '', 'Wisconsin', 'Michigan', ''],
    ['1/22/2023', '', 'Michigan', 'Rutgers', ''],
    ['1/29/2023', '', 'Maryland', 'Michigan', ''],
    ['2/12/2023', '', 'Indiana', 'Michigan', ''],
    ['2/19/2023', '', 'Central Michigan', 'Michigan', ''],
    ['1/13/2023', '20:00', 'Minnesota', 'Nebraska', 'BTN'],
    ['1/15/2023', '19:00', 'Michigan State', 'Minnesota', 'BTN'],
    ['1/20/2023', '', 'Minnesota', 'Indiana', 'BTN+'],
    ['1/22/2023', '13:00', 'Purdue', 'Minnesota', 'BTN+'],
    ['1/28/2023', '13:00', 'Illinois', 'Minnesota', 'BTN'],
    ['12/18/2022', '14:00', 'Nebraska', 'South Dakota State', ''],
    ['1/7/2023', '14:00', 'Nebraska', 'Campbell', ''],
    ['1/7/2023', '16:00', 'Nebraska', 'Gardner-Webb', ''],
    ['1/29/2023', '', 'Wisconsin', 'Nebraska', ''],
    ['2/3/2023', '', 'Nebraska', 'Illinois', ''],
    ['2/5/2023', '', 'Nebraska', 'Purdue', ''],
    ['2/12/2023', '', 'Rutgers', 'Nebraska', ''],
    ['12/19/2022', '10:00', 'Iowa State', 'Oregon State', ''],
    ['1/7/2023', '14:00', 'Wyoming', 'Iowa State', ''],
    ['1/27/2023', '19:00', 'Oklahoma', 'Iowa State', ''],
    ['2/3/2023', '18:00', 'Iowa State', 'West Virginia', ''],
    ['2/4/2023', '18:00', 'Iowa State', 'Pittsburgh', ''],
    ['2/12/2023', '12:00', 'Illinois', 'Iowa State', ''],
    ['12/4/2022', '11:30', 'Wisconsin', 'Princeton', ''],
    ['1/8/2023', '15:00', 'Wisconsin', 'Illinois', 'BTN'],
    ['1/20/2023', '19:00', 'Purdue', 'Wisconsin', 'BTN+'],
    ['2/11/2023', '13:00', 'Minnesota', 'Wisconsin', 'BTN'],
    ['2/18/2023', '19:00', 'Northern Iowa', 'Wisconsin', ''],
    ['12/18/2022', '13:00', 'Virginia Tech', 'Stanford', ''],
    ['1/12/2023', '16:30', 'North Dakota State', 'Stanford', ''],
    ['1/15/2023', '10:00', 'Penn', 'Stanford', ''],
    ['1/20/2023', '18:00', 'NC State', 'Virginia Tech', ''],
    ['1/27/2023', '18:00', 'Pittsburgh', 'NC State', ''],
    ['2/3/2023', '18:00', 'Virginia Tech', 'Duke', ''],
    ['2/10/2023', '18:00', 'Virginia Tech', 'North Carolina', ''],
    ['2/17/2023', '18:00', 'Virginia', 'Virginia Tech', ''],
    ['1/27/2023', '18:00', 'Duke', 'NC State', ''],
    ['2/3/2023', '18:00', 'NC State', 'Virginia', ''],
    ['2/10/2023', '18:00', 'Pittsburgh', 'NC State', ''],
    ['2/17/2023', '18:00', 'NC State', 'North Carolina', ''],
    ['11/26/2022', '14:00', 'Penn', 'Iowa', ''],
    ['12/4/2022', '11:30', 'Penn', 'Rutgers', ''],
    ['12/4/2022', '13:30', 'Penn', 'Wisconsin', ''],
    ['1/7/2023', '19:00', 'North Carolina', 'Penn', ''],
    ['1/15/2023', '12:00', 'Penn', 'Stanford', ''],
    ['1/20/2023', '17:00', 'Lehigh', 'Penn', ''],
    ['1/22/2023', '12:00', 'Penn', 'Columbia', ''],
    ['1/27/2023', '18:00', 'Brown', 'Penn', ''],
    ['1/28/2023', '18:00', 'Harvard', 'Penn', ''],
    ['2/10/2023', '18:00', 'Princeton', 'Penn', ''],
    ['12/4/2022', '15:00', 'Michigan State', 'Princeton', ''],
    ['12/11/2022', '13:00', 'Rutgers', 'Princeton', ''],
    ['1/13/2023', '18:00', 'Princeton', 'Oregon State', ''],
    ['1/20/2023', '18:00', 'Princeton', 'Columbia', ''],
    ['1/21/2023', '18:00', 'Rider', 'Princeton', ''],
    ['1/27/2023', '17:00', 'Harvard', 'Princeton', ''],
    ['1/28/2023', '17:00', 'Brown', 'Princeton', ''],
    ['2/4/2023', '16:00', 'Princeton', 'Binghamptom', ''],
    ['2/11/2023', '17:00', 'Lehigh', 'Princeton', ''],
    ['2/17/2023', '18:00', 'Princeton', 'Bucknell', ''],
    ['12/19/2022', '20:00', 'Lehigh', 'NC State', ''],
    ['1/15/2023', '12:00', 'Lehigh', 'Binghamptom', ''],
  ]
end

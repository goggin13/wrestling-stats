class RawSchedule
  def self.ingest
    matches.each do |data|
      away_team = College.find_by!(name: data[1])
      home_team = College.find_by!(name: data[2])
      time = data[3]
      watch_on = data[4]
      date = Date.strptime(data[0], "%m/%d/%y")
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

  MATCHES = [
    ['01/21/22', 'Maryland', 'Indiana'],
    ['01/21/22', 'Penn State', 'Michigan'],
    ['01/21/22', 'Rutgers', 'Michigan State'],
    ['01/21/22', 'Iowa', 'Ohio State'],
    ['01/21/22', 'Illinois', 'Purdue'],
    ['01/21/22', 'Nebraska', 'Wisconsin'],
    ['01/23/22', 'Rutgers', 'Michigan'],
    ['01/23/22', 'Penn State', 'Michigan State'],
    ['01/23/22', 'Nebraska', 'Northwestern'],
    ['01/23/22', 'Maryland', 'Ohio State'],
    ['01/23/22', 'Wisconsin', 'Purdue'],
    ['01/28/22', 'Penn State', 'Iowa'],
    ['01/28/22', 'Wisconsin', 'Maryland'],
    ['01/28/22', 'Minnesota', 'Michigan'],
    ['01/29/22', 'Northwestern', 'Illinois'],
    ['01/29/22', 'Purdue', 'Indiana'],
    ['01/30/22', 'Michigan', 'Maryland'],
    ['02/04/22', 'Minnesota', 'Illinois'],
    ['02/04/22', 'Michigan State', 'Maryland'],
    ['02/04/22', 'Michigan', 'Nebraska'],
    ['02/04/22', 'Ohio State', 'Penn State'],
    ['02/05/22', 'Wisconsin', 'Iowa'],
    ['02/06/22', 'Indiana', 'Illinois'],
    ['02/06/22', 'Maryland', 'Northwestern'],
    ['02/06/22', 'Minnesota', 'Purdue'],
    ['02/06/22', 'Ohio State', 'Rutgers'],
    ['02/06/22', 'Nebraska', 'Penn State'],
    ['02/11/22', 'Michigan', 'Indiana'],
    ['02/11/22', 'Northwestern', 'Michigan State'],
    ['02/11/22', 'Ohio State', 'Minnesota'],
    ['02/11/22', 'Illinois', 'Wisconsin'],
    ['02/12/22', 'Maryland', 'Rutgers'],
    ['02/13/22', 'Michigan State', 'Michigan'],
    ['02/13/22', 'Illinois', 'Nebraska'],
    ['02/13/22', 'Indiana', 'Ohio State'],
    ['02/19/22', 'Purdue', 'Northwestern'],
    ['02/20/22', 'Iowa', 'Nebraska'],
    ['02/20/22', 'Cornell', 'Wisconsin'],
    ['01/20/22', 'Missouri', 'Oklahoma'],
    ['01/22/22', 'Missouri', 'South Dakota State'],
    ['02/06/22', 'Missouri', 'Oklahoma State'],
    ['02/12/22', 'Missouri', 'Arizona State'],
    ['02/16/22', 'Missouri', 'Iowa State'],
    ['01/30/22', 'Iowa State', 'Oklahoma State', '14:00'],
    ['02/12/22', 'Iowa', 'Oklahoma State'],
    ['02/20/22', 'Oklahoma', 'Oklahoma State'],
    ['02/11/22', 'NC State', 'Pittsburgh'],
    ['01/30/22', 'Virginia Tech', 'Pittsburgh', '14:00'],
    ['02/12/22', 'Virginia Tech', 'Missouri'],
    ['02/04/22', 'Stanford', 'Arizona State'],
    ['01/28/22', 'Iowa State', 'Oklahoma', '19:00'],
    ['02/12/22', 'Cal Poly', 'Stanford', '19:00'],
  ]
end

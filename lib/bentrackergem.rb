require "bentrackergem/version"
require "rest_client"
require "json"

module Bentrackergem

  URL = 'http://brostofftrack.herokuapp.com/history.json'
  HISTORY = JSON.parse(RestClient.get URL).to_h["days"]
  
  def self.day_stats(date)
    HISTORY.each do |summary|
      if summary["day_of"] == date
        return {:message => summary["message"],
                :code => summary["code"],
                :fitness => summary["fitness"]}
      end
    end
    return "Date not found."
  end

end

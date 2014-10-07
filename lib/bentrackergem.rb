require "bentrackergem/version"
require "rest_client"
require "json"
require "date"

module BenTrackerGem

  URL = 'http://brostofftrack.herokuapp.com/history.json'
  HISTORY = JSON.parse(RestClient.get URL).to_h["days"]
  
  def self.valid_format(date)
    DateTime.parse(date, "%Y-%m-%d").to_s[0..9]
  end

  def self.day_stats(date)
    date = valid_format(date)
    if date > valid_format(Time.now.to_s) || date < "2014-09-30"
      raise ArgumentError, "Date outside range (data begins 2014-09-30)"
    end
    HISTORY.each do |summary|
      if summary["day_of"] == date
        return {:message => summary["message"],
                :code => summary["code"],
                :fitness => summary["fitness"]}
      end
    end
  end

end

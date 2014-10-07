require "bentrackergem/version"
require "rest_client"
require "json"
require "date"

module BenTrackerGem

  URL = 'http://brostofftrack.herokuapp.com/history.json'
  HISTORY = JSON.parse(RestClient.get URL).to_h["days"]
  
  def self.valid_format(date)
    date = DateTime.parse(date, "%Y-%m-%d").to_s[0..9]
    now = Time.now.to_s[0..9]
    if date > now || date < "2014-09-30"
      raise ArgumentError, "Date outside range (data begins 2014-09-30)"
    end
    date
  end

  def self.filter_hash(hash)
    {:message => hash["message"],
     :code => hash["code"],
     :fitness => hash["fitness"]}
  end

  def self.day_stats(date)
    date = valid_format(date)
    HISTORY.each do |summary|
      if summary["day_of"] == date
        return filter_hash(summary)
      end
    end
  end

  def self.date_range(begin_date, end_date)
    begin_date, end_date, hold = valid_format(begin_date), valid_format(end_date), []
    filter = HISTORY.select { |summary| summary["day_of"] >= begin_date && 
                              summary["day_of"] <= end_date }.
                              map { |summary| day_stats(summary["day_of"]) }
  end   

end

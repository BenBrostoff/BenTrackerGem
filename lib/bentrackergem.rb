require "bentrackergem/version"
require "chronic"
require "rest_client"
require "json"
require "date"

module BenTrackerGem

  URL_GET = 'http://brostofftrack.herokuapp.com/history.json'
  URL_POST = 'http://brostofftrack.herokuapp.com/email'

  VALID_CATS = ["message", "code", "fitness"]

  def self.get_history
    JSON.parse(RestClient.get URL_GET).to_h["days"]
  end
  
  def self.valid_format(date)
    date = DateTime.parse(date, "%Y-%m-%d").to_s[0..9]
    now = Time.now.to_s[0..9]
    if date > now || date < "2014-09-30"
      raise ArgumentError, "Date outside range (data begins 2014-09-30)"
    end
    date
  end

  def self.filter_hash(hash)
    {:day_of => hash["day_of"],
     :message => hash["message"],
     :code => hash["code"],
     :fitness => hash["fitness"]}
  end

  def self.day_stats(date)
    date = valid_format(date)
    get_history.each do |summary|
      if summary["day_of"] == date
        return filter_hash(summary)
      end
    end
  end

  def self.date_range(begin_date, end_date)
    begin_date, end_date, hold = valid_format(begin_date), valid_format(end_date), []
    filter = get_history.select { |summary| summary["day_of"] >= begin_date && 
                              summary["day_of"] <= end_date }.
                              map { |summary| day_stats(summary["day_of"]) }.
                              sort_by { |summary| summary[:day_of] }
  end   

  def self.date_range_visual(req, begin_date, end_date, sort = 0)
    raise ArgumentError, "must select valid category" if !VALID_CATS.include? req

    filter = date_range(begin_date, end_date)
    filter = filter.reverse if sort == 1
    filter.each do |visi|
      puts visi[:day_of] + ". " + visi[req.to_sym].to_s
    end
    "COMPLETE"
  end

  def self.post_message(message)
    raise ArgumentError, "must enter message as String" if !message.is_a? String

    RestClient.post URL_POST, { 'message' => message }.to_json, 
      :content_type => :json, 
      :accept => :json
  end

end

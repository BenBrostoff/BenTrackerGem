require "bentrackergem/version"
require "chronic"
require "rest_client"
require "json"
require "date"

module BenTrackerGem

  HISTORY = 'http://brostofftrack.herokuapp.com/history.json'
  BOOK_HISTORY = 'http://brostofftrack.herokuapp.com/book_history.json'
  URL_POST = 'http://brostofftrack.herokuapp.com/email'

  VALID_CATS = ["message", "code", "fitness",
                "author", "title", "time_reading"]

  def self.get_history
    JSON.parse(RestClient.get HISTORY).to_h["days"]
  end

  def self.get_book_history
    books = JSON.parse(RestClient.get BOOK_HISTORY).to_h["books"]
    books.each do |book|
      book["created_at"] = book["created_at"][0..9]
    end
    return books
  end
  
  def self.valid_format(date)
    date = DateTime.parse(date, "%Y-%m-%d").to_s[0..9]
    now = Time.now.to_s[0..9]
    if date > now || date < "2014-09-30"
      raise ArgumentError, "Date outside range (data begins 2014-09-30)"
    end
    date
  end

  def self.filter_hash(hash, book_flag = 0)
    if book_flag == 0
      return {:day_of => hash["day_of"],
              :message => hash["message"],
              :code => hash["code"],
              :fitness => hash["fitness"]}
    else
      return {:created_at => hash["created_at"],
              :title => hash["title"],  
              :author => hash["author"],
              :time_reading => hash["time_reading"]}
    end
  end

  def self.day_stats(date, book_flag = 0)
    date = valid_format(date)
    all, key = get_history, "day_of" if book_flag == 0
    all, key = get_book_history, "created_at" if book_flag == 1
    all.each do |summary|
      if summary[key] == date
        return filter_hash(summary, book_flag)
      end
    end
  end

  def self.date_range(begin_date, end_date, book_flag = 0)
    begin_date, end_date, hold = valid_format(begin_date), valid_format(end_date), []
    all, key = get_history, "day_of" if book_flag == 0
    all, key = get_book_history, "created_at" if book_flag == 1

    all.select { |summary| summary[key] >= begin_date && 
                                           summary[key] <= end_date }.
                map { |summary| day_stats(summary[key], book_flag) }.
                sort_by { |summary| summary[key.to_sym] }
  end   

  def self.date_range_visual(req, begin_date, end_date, book_flag = 0, sort = 0)
    raise ArgumentError, "must select valid category" if !VALID_CATS.include? req

    filter, key = date_range(begin_date, end_date), "day_of".to_sym if book_flag == 0
    filter, key = date_range(begin_date, end_date, 1), "created_at".to_sym if book_flag == 1
    filter = filter.reverse if sort == 1
    
    filter.each do |visi|
      puts visi[key.to_sym] + ". " + visi[req.to_sym].to_s if book_flag == 0
      puts visi[key.to_sym] + ". " + visi[:title].to_s + " by " +  visi[:author].to_s if book_flag == 1
    end
    "COMPLETE"
  end

  def self.diary(begin_date = "last week", end_date = "today")
    date_range_visual("message", 
                      Chronic.parse(begin_date).to_s[0..9],
                      Chronic.parse(end_date).to_s[0..9])
  end

  def self.book_diary(begin_date = "last week", end_date = "today")
     date_range_visual("title", 
                      Chronic.parse(begin_date).to_s[0..9],
                      Chronic.parse(end_date).to_s[0..9],
                      1)
  end

  def self.post_message(message)
    raise ArgumentError, "must enter message as String" if !message.is_a? String

    # Must have valid credentials as environment variables 
    user = ENV['bg_user']
    pass = ENV['bg_pass']
    curl = "curl -d message='#{message}' -u #{user}:#{pass} #{URL_POST}"
    system(curl)
  end

end

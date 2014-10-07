require 'Bentrackergem'

describe 'BenTrackerGem' do

  let (:response_get) { RestClient.get('http://brostofftrack.herokuapp.com/history.json') }
  let (:response_post) { BenTrackerGem.post_message("Test Suite") }

  context "get-based methods" do 

    it "successfully gets the data " do 
      expect(response_get.code).to eq(200)
    end

  end

  context "#post_message" do
    
    it "raises an error if the user does not enter a message as String" do
      expect{
        BenTrackerGem.post_message(12345)
        }.to raise_error(ArgumentError, "must enter message as String")
    end

    it "successfully posts the data " do 
      expect(response_post.code).to eq(200)
      expect(response_post).to eq("{}")
  end

  end

  context "#valid_format" do 
    
    it "should raise an argument error for invalid date format" do 
      expect{ 
        BenTrackerGem.valid_format("COO") 
        }.to raise_error(ArgumentError, "invalid date")
    end

    it "should raise an argument error if date is outside range" do 
      expect {
        BenTrackerGem.valid_format("2014-01-01")
      }.to raise_error(ArgumentError, "Date outside range (data begins 2014-09-30)")
    end

  end

  context "#day_stats" do 

    it "should return a summary of the day in hash format" do
      expect(BenTrackerGem.day_stats("2014-10-06")).to eq({
         :day_of => "2014-10-06",
         :code => 6,
         :fitness => 15142,
         :message => "Interview with Avant. Run. Working on app."
        })
    end

  end

  context "#date_range" do 

    it "should return an array of day summaries given valid begin and end dates" do
      expect(BenTrackerGem.date_range("2014-10-03", "2014-10-05")).to eq(
        [BenTrackerGem.day_stats("2014-10-03"),
         BenTrackerGem.day_stats("2014-10-04"),
         BenTrackerGem.day_stats("2014-10-05")]
        )
    end

  end

  context "#date_range_visual" do 

    it "should raise an error if user requests invalid category" do 
      expect{ 
        BenTrackerGem.date_range_visual("COO", "2014-10-03", "2014-10-05")  
        }.to raise_error(ArgumentError, "must select valid category")
    end

    it "should execute without error when valid category and dates are input" do
      expect( 
        BenTrackerGem.date_range_visual("message", "2014-10-03", "2014-10-06")  
        ).to eq("COMPLETE")
    end

  end

end
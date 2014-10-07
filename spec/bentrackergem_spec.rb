require 'Bentrackergem'

describe 'BenTrackerGem' do

  let (:response) { RestClient.get('http://brostofftrack.herokuapp.com/history.json') }
  
  it "successfully gets the data " do 
    expect(response.code).to eq(200)
  end

  it "should raise an argument error for invalid date format" do 
    expect{ 
      BenTrackerGem.day_stats("COO") 
      }.to raise_error(ArgumentError)
  end

  it "should return a summary of the day in hash format" do
    expect(BenTrackerGem.day_stats("2014-10-06")).to eq({
       :code => 6,
       :fitness => 14705,
       :message => "Interview with Avant. Run. Working on app."
      })
  end

end
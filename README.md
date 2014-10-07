# BenTrackerGem

A gem that records my daily FitBit steps, GitHub contributions and summaries I write to myself. The intent here is for the gem to function as a personal API diary; as of this writing, it has little utility beyond me (unless you wish to know what I did on a given day). 

## Installation

Add this line to your application's Gemfile:

    gem 'bentrackergem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bentrackergem

## Usage

Post today's summary:

`BenTrackerGem.post_message("What a great day!")`

Get today's stats:

`BenTrackerGem.day_stats("2014-10-06")`

Get multiple days of stats:

`BenTrackerGem.date_range("2014-09-30", "2014-10-05")`

Get visual output of specific category:

`BenTrackerGem.date_range_visual("code", "2014-10-03", "2014-10-06")`

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bentrackergem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

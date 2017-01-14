# ExchangeRate

A small foreign exchange library.

## Installation

*Clone and `bundle exec rake install` to install this Gem. It does not exist on RubyGems as yet.*

## Documentation

Docs are provided in `doc/`, due to issues getting this onto RubyGems. Clone the repo then `open doc/index.html` to view.

## Usage

The current implementation is designed to work with the [90-day ECB feed](https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml). Grab a copy of that,
and pop the location on disk into an environment variable:

`export XML_FEED_PATH=/path/to/feed.xml` or `ENV["XML_FEED_PATH"]=/path/to/feed.xml` if you want to avoid added to your global env.

The library exposes the following interface:

```Ruby
require 'exchange_rate'

ExchangeRate.at(date<String|Date>, currency_from<String>, currency_to<String>)

# e.g. 

ExchangeRate.at(Date.today, "USD", "EUR")
#=> 0.93642
```

`currency_from` and `currency_to` must be three-letter ISO codes, but can be either upper or lowercase.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. `SimpleCov` will output a coverage report to `/coverage`
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mattfield/exchange_rate.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


# ExchangeRate

A small foreign exchange library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exchange_rate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exchange_rate

## Usage

ExchangeRate expects you to define the location on disk of the ECB feed to pull from. This should be done in an envvar:

`export XML_FEED_PATH=/path/to/feed.xml`

The library exposes the following interface:

```Ruby
require 'exchange_rate'

ExchangeRate.at(date, currency_from, currency_to)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mattfield/exchange_rate.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


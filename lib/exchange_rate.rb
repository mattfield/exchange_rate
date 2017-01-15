require "exchange_rate/version"
require "exchange_rate/quote"

module ExchangeRate
  # Request an exchange rate
  #
  # @param date [Date|String] Date of either type Date or String
  # @param from [String] Currency to convert from 
  # @param to [String] Currency to convert to
  # @return [Float] Exchange rate
  def ExchangeRate.at(date, from, to)
    ECBQuote.new({
      'date' => date,
      'from' => from,
      'to'   => to
    }).get_conversion_rate
  end

  # Request all exchange rates for a certain date
  #
  # @param date [Date|String] Date of either type Date or String
  # @return [Hash<String, String>] Hash of { currency => rate } pairs
  def ExchangeRate.all_rates_at(date)
    ECBQuote.new({
      'date' => date
    }).rates
  end

  # Request all exchange rates from the entire feed
  #
  # @return [Array<Hash>] Array of hashes { date, currency, rate }
  def ExchangeRate.all_rates
    rates = []
    ECBFeed.new().each { |rate| rates << rate }
    rates
  end

  # Request all available currencies for a certain date
  #
  # @return [Array<String>] Array of available currencies
  def ExchangeRate.all_currencies_at(date)
    ECBQuote.new({
      'date' => date
    }).get_currencies_by_date
  end
end

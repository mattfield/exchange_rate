require "exchange_rate/version"
require "exchange_rate/quote"

module ExchangeRate
  # Request an exchange rate
  #
  # @param date [Date] Date object
  # @param base_curr [String] Currency to convert from 
  # @param counter_curr [String] Currency to convert to
  # @return [Numeric] Exchange rate of base_curr to counter_curr
  def ExchangeRate.at(date, base_curr, counter_curr)
    Quote.new({
      'date' => date,
      'from' => base_curr,
      'to'   => counter_curr
    }).get_conversion_rate
  end
end

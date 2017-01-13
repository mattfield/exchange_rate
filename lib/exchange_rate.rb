require "exchange_rate/version"
require "exchange_rate/quote"

module ExchangeRate
  # Request an exchange rate
  #
  # @param date [Date|String] Date of eithe type Date or String
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
end

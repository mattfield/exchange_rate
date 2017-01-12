require "exchange_rate/version"

module ExchangeRate
  # Request an exchange rate
  #
  # @param date [Date] Date object
  # @param base_curr [String] Currency to convert from 
  # @param counter_curr [String] Currency to convert to
  # @return [Numeric] Exchange rate of base_curr to counter_curr
  def ExchangeRate.at(date, base_curr, counter_curr)
  end
end

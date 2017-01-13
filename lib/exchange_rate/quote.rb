require 'exchange_rate/feed'
require 'exchange_rate/helper'
require 'date'

class Quote
  DEFAULT_AMOUNT = 1
  DEFAULT_FROM = 'EUR'

  def initialize(options = {})
    @date = options['date'].is_a?(String) ? Date.parse(options['date']) : options['date']
    @amount = options['amount'] || DEFAULT_AMOUNT
    @from = options['from'].upcase || DEFAULT_FROM
    @to = options['to'].upcase
    rates
  end

  attr_reader :amount, :date, :from, :to

  # Sets the rates of the Quote class
  #
  # @return [Hash<String, String>] A hash of { currency => rate } pairs
  def rates
    @rates ||= get_rates
  end

  # Calculates the conversion rate between two currencies
  #
  # @return [Float] The calculated conversion rate
  def get_conversion_rate
    rates[DEFAULT_FROM] = DEFAULT_AMOUNT.to_s

    if !rates[@to.to_s] || !rates[@from.to_s]
      raise Exception, "FX error - either from or to currencies do not exist, or were not provided"
    end

    if @from.to_s == DEFAULT_FROM
      return round(rates[@from])
    end

    if @to.to_s == DEFAULT_FROM
      return round(1 / round(rates[@from]))
    end

    round(round(rates[@to]) * (1 / round(rates[@from])))
  end

  # Formats a given numeric value as a Float
  # to five decimal places
  #
  # @param [Numeric] Any numeric type to round
  # @return [Float] Float-converted Numeric to 5d.p.
  def round value
    Float(format('%.5g', value))
  end
end

class ECBQuote < Quote
  # Fetches and calculates the conversation rates for
  # a given date
  #
  # @return [Hash<String, String>] A hash of { currency => rate } pairs
  def get_rates
    new_rates = []

    ECBFeed.new().each { |rate|
      new_rates << rate
    }

    # Make sure any dates are rounded
    # back to the nearest last weekday 
    # (as the ECB feed does not have rates
    # mapped to weekend dates
    @date = Helper::ensure_weekday(date_in_range?(@date, new_rates))

    get_rates_by_date(@date, new_rates)
  end

  # Computes a range of conversion state for a specific date
  #
  # @param date [Date] The date to fetch rates for
  # @param new_rates [Array<Hash>] An array of all rates for all
  #   dates in the feed
  # @return [Hash<String, String>] A hash of { currency => rate } pairs
  def get_rates_by_date(date = @date, new_rates)
    rate_nodes = new_rates.select { |date_node|
      date_node[:date] == @date
    }

    rate_nodes.reduce({}) { |rates, currency|
      rates[currency[:iso]] = currency[:rate]
      rates
    }
  end

  # Checks whether a given date is in range for the rates
  # we have available in the feed. Also optionally 
  # decrements the provided date by 1 if the feed being
  # used has not yet been updated for the day, meaning
  # today's rates will not yet be available
  #
  # @param date [Date] Date to check
  # @param new_rates [Array<Hash>] An array of all rates for all
  #   dates in the feed
  # @return [Date|Exception] Either returns the date passed in,
  #   a decremented date, or an Exception if the given date
  #   is out of range
  def date_in_range?(date = @date, new_rates = @rates)
    # ECB feed rates for the day are not updated until ~4pm CET.
    # In the case where we want the rates for today, but we still have
    # yesterday's feed, we need to step the query date back by a day
    if date == Date.today
      if new_rates.first[:date] != date
        date = date - 1
      end
    end

    # ECB feed only contains 3 months of data, so we need to check
    # to see whether the supplied date falls into that range.
    # If it doesn't, we throw an exception and bail
    oldest_date = (Date.today << 3)

    return date if date >= oldest_date

    raise Exception, 'Invalid date - must be within last 3 months'
  end
end

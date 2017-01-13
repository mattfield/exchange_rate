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

  def rates
    @rates ||= get_rates
  end

  def date=(value)
    @date = value ? date_in_range?(value) : @date
  end

  def from=(value)
    @from = value.upcase || DEFAULT_FROM
  end

  def to=(value)
    @to = value.upcase || @to
  end

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

  def round value
    Float(format('%.5g', value))
  end
end

class ECBQuote < Quote
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

  def get_rates_by_date(date = @date, new_rates)
    rate_nodes = new_rates.select { |date_node|
      date_node[:date] == @date
    }

    rate_nodes.reduce({}) { |rates, currency|
      rates[currency[:iso]] = currency[:rate]
      rates
    }
  end

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
    false
  end
end

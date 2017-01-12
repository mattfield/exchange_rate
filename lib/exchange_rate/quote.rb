require 'exchange_rate/feed'
require 'exchange_rate/helper'

class Quote
  DEFAULT_AMOUNT = 1
  DEFAULT_FROM = 'EUR'

  def initialize(options = {})
    @date = options['date']
    @amount = options['amount'] || DEFAULT_AMOUNT
    @from = options['from'] || DEFAULT_FROM
    @to = options['to']
    rates
  end

  attr_reader :amount, :date, :from, :to

  def rates
    @rates ||= get_rates
  end

  def date=(value)
    @date = value ? date_in_range?(value) : @date
  end

  def amount=(value)
    @amount = (value || DEFAULT_AMOUNT).to_f
    raise StandardError, 'Invalid amount - must be greater than zero' if @amount.zero?
  end

  def from=(value)
    @from = value.upcase || DEFAULT_FROM
  end

  def get_rates
    rates = using_default_from? ? get_default_rates : get_updated_rates
  end

  def get_default_rates
    new_rates = ECBFeed.new().each do |rate|
      rate
    end

    date = ensure_weekday @date

    REXML::XPath.each(new_rates, "[@time='#{date.xmlschema}']") do |rate|
      return rate.children.reduce({}){ |cumulate, entry|
        key = entry.attribute('currency').value
        value = entry.attribute('rate').value
        cumulate[key] = value
        cumulate
      }
    end
  end

  def get_updated_rates
  end

  def using_default_from?
    from == DEFAULT_FROM
  end

  def ensure_weekday date
    # Make sure any dates are rounded
    # back to the nearest last weekday 
    # (as the ECB feed does not have rates
    # mapped to weekend dates
    Helper::ensure_weekday(date)
  end

  def date_in_range?(date = @date)
    oldest_date = rates.last[:date]

    return date if date >= oldest_date

    raise Exception, 'Date too old - must be within last 3 months'
    false
  end
end

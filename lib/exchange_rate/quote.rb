require 'exchange_rate/feed'
require 'exchange_rate/helper'

class Quote
  DEFAULT_AMOUNT = 1
  DEFAULT_BASE = 'EUR'

  def rates
    @rates ||= get_rates
  end

  def get_rates
    ECBFeed.new().each do |rate|
      rate
    end
  end

  def get_rates_by_date date
    # Make sure any dates coming in get converted to
    # xmlschema standard i.e. YYYY-MM-DD
    date = Helper::ensure_weekday(Date.parse(date).xmlschema)

    REXML::XPath.each(get_rates, "[@time='#{date}']") do |rate|
      return rate.children.reduce({}){ |cumulate, entry|
        key = entry.attribute('currency').value
        value = entry.attribute('rate').value
        cumulate[key] = value
        cumulate
      }
    end
  end
end

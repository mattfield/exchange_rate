module Helper
  # Checks whether a provided date is a weekday
  #
  # @param date [Date] The date to be checked
  # @return [Boolean] Whether date is a weekend
  def Helper::is_weekday? date
    day = date.wday
    if (1..5).include? day
      true
    else
      false
    end
  end

  # Ensures that a given date resolved backwards
  # to the nearest available weekday
  #
  # @param date [Date] The date to be checked
  # @return [Date] Either the provided date or date
  #   of closest, previous weekday
  def Helper::ensure_weekday date
    return date if is_weekday?(date)

    back_to = date - 5
    return_date = nil

    date.step(back_to, -1) { |d|
      if is_weekday?(d)
        return_date = d
        break
      end
    }

    return_date
  end
end

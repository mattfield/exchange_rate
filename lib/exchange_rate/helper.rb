module Helper
  def Helper::is_weekday? date
    day = date.wday
    if (1..5).include? day
      true
    else
      false
    end
  end

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

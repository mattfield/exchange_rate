module Helper
  def Helper::is_weekday? date
    day = Date.parse(date).wday
    if (1..5).include? day
      true
    else
      false
    end
  end

  def Helper::ensure_weekday date
    return date if is_weekday?(date)

    back_to = Date.parse(date) - 5
    return_date = nil

    Date.parse(date).step(back_to, -1) { |d|
      if is_weekday?(d.to_s)
        return_date = d
        break
      end
    }

    return_date.xmlschema
  end
end

module ApplicationHelper
  
  def time_helper time
    arr = time.split('-')
    arr[0] + " Days " + arr[1] + " Nights"
  end

  def date_formatter date
    (date + 7.hours).strftime("%a, %b %d, %y %H:%M")
  end
end

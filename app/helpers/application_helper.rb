module ApplicationHelper

  def display_date(date)
    date.strftime("%a - %-m/%d/%y @ %l:%M %P")
  end

end

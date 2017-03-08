module ApplicationHelper
  def display_date(date)
    date.strftime("%a - %-m/%d/%y @ %l:%M %P")
  end

  def back_button(path: :back)
    link_to path, class: "btn btn-default" do
      content_tag(:span, "", class: "glyphicon glyphicon-chevron-left", 'aria-hidden': "true") + "&nbsp;Back".html_safe
    end
  end
end

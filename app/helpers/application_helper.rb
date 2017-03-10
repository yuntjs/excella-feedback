#
# ApplicationHelper
#
module ApplicationHelper
  #
  # Helper to format datetime
  #
  def display_date(date)
    date.strftime('%a - %-m/%d/%y @ %l:%M %P')
  end

  #
  # Helper to render a uniform back button
  # Defaults to :back path if none is specified
  #
  def back_button(path = :back)
    link_to path, class: 'btn btn-default' do
      content_tag(:span, '', class: 'glyphicon glyphicon-chevron-left', aria_hidden: 'true') + '&nbsp;Back'.html_safe
    end
  end
end

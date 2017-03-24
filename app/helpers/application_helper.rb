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

  #
  # Renders error messages for login
  #
  def login_errors(flash)
    return unless flash.alert
    content_tag(:div, flash.alert, class: 'has-error text-danger')
  end

  #
  # Add error class if object has errors
  #
  def error_class(object)
    object.errors.any? ? 'has-error' : ''
  end

  #
  # Add list of errors below response
  #
  def error_messages(object)
    return unless object.errors.any?
    content_tag(:div,
                content_tag(:ul,
                            render_list(object.errors.full_messages),
                            class: 'error-list'),
                class: 'has-error text-danger')
  end

  #
  # Provides all messages from an array as <li>
  # TODO: refactor with .inject
  #
  def render_list(messages)
    result = ''
    messages.each do |msg|
      result += content_tag(:li, msg)
    end
    result.html_safe
  end
end

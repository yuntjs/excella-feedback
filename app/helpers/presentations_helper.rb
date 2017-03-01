module PresentationsHelper

  def display_description(presentation)
    if presentation.description.length > 30
      content_tag(:span, presentation.description_short(30)) +
      content_tag(:a, '(more)',
        tabindex: '0',
        role: 'button',
        data: {
          toggle: 'popover',
          placement: 'bottom',
          trigger: 'focus',
          content: presentation.description
        }
      )
    else
      presentation.description
    end
  end

end

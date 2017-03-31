require 'test_helper'

class PresentationsHelperTest < ActionView::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @user = create(:user)
    @admin = create(:user, :admin)

    @presentation_as_presenter = create(:presentation)
    @presentation_as_attendee = create(:presentation)
    @presentation_as_admin_attendee = create(:presentation)
    @presentation_as_admin_presenter = create(:presentation)
    @future_presentation_as_attendee = create(:presentation, :in_the_future)
    @future_presentation_as_presenter = create(:presentation, :in_the_future)

    create(:participation,
           user_id: @user.id,
           presentation_id: @presentation_as_presenter.id,
           is_presenter: true)

    create(:participation,
           user_id: @user.id,
           presentation_id: @presentation_as_attendee.id,
           is_presenter: false)

    create(:participation,
           user_id: @admin.id,
           presentation_id: @presentation_as_admin_attendee.id,
           is_presenter: false)

    create(:participation,
           user_id: @admin.id,
           presentation_id: @presentation_as_admin_presenter.id,
           is_presenter: true)

    create(:participation,
           user_id: @user.id,
           presentation_id: @future_presentation_as_attendee.id,
           is_presenter: false)

    create(:participation,
           user_id: @user.id,
           presentation_id: @future_presentation_as_presenter.id,
           is_presenter: true)
  end

  describe '#presentations_as' do
    it 'gets correct presentations when current user is presenter' do
      presentations = presentations_as(:presenter, @user)

      assert_equal presentations.length, 2
      assert presentations.include?(@presentation_as_presenter)
      assert presentations.include?(@future_presentation_as_presenter)
    end

    it 'gets correct presentations where current user is attendee' do
      presentations = presentations_as(:attendee, @user)

      assert_equal presentations.length, 2
      assert presentations.include?(@presentation_as_attendee)
      assert presentations.include?(@future_presentation_as_attendee)
    end

    it 'returns an empty relation is role is not specified as presenter or attendee' do
      assert_equal presentations_as(:another_role, @user), []
    end

    it 'raises an error if role is not specified' do
      assert_raises(ArgumentError) { presentations_as(@user) }
    end

    it 'raises an error if user is not specified' do
      assert_raises(ArgumentError) { presentations_as(:presenter) }
    end
  end

  describe '#admin_table' do
    it 'renders a partial if user is an admin'

    it 'returns nil if user is not an admin' do
      assert_nil admin_table(@user), 'Expected to return nil if user is not admin'
    end
  end

  describe '#general_user_table' do
    it 'renders a partial if user is involved in presentations as a given role'

    it 'renders nil if user is not involved in presentations as a given role' do
      another_user = create(:user)

      assert_nil general_user_table(user: another_user, role: :presenter, title: 'Title', feedback_message: 'Feedback Message'), 'Expected to return nil'
    end
  end

  describe '#feedback_header' do
    it 'returns "Admin" when argument is not "As Presenter" or "As Attendee"' do
      text = feedback_header('As Admin')

      assert_equal text, 'Admin', 'Returns something other than "Admin"'
    end

    it 'returns "Feedback" when argument is "As Presenter" or "As Attendee"' do
      text1 = feedback_header('As Presenter')
      text2 = feedback_header('As Attendee')

      assert_equal text1, 'Feedback', 'Returns something other than "Feedback"'
      assert_equal text2, 'Feedback', 'Returns something other than "Feedback"'
    end
  end

  describe '#display_description' do
    let(:char_limit) { 30 }

    it 'returns the presentation description if its length is less than the char limit' do
      @presentation_as_attendee.description = 'a' * (char_limit - 1)

      assert_equal display_description(@presentation_as_attendee), @presentation_as_attendee.description,
                   'Expected the entire presentation description'
    end

    it 'returns the presentation description if its length equals the char limit' do
      @presentation_as_attendee.description = 'a' * char_limit

      assert_equal display_description(@presentation_as_attendee), @presentation_as_attendee.description,
                   'Expected the entire presentation description'
    end

    it 'returns a shortened presentation description if its length exceeds the char limit' do
      @presentation_as_attendee.description = 'a' * (char_limit + 1)

      description = display_description(@presentation_as_attendee)
      short_span_description = '<span>' + @presentation_as_attendee.description[0..char_limit] + '</span>'

      assert_includes description, short_span_description, 'Expected output does not include shortened description'
      assert_includes description, '(more)', 'Expected output does not include "(more)"'
    end

    it 'returns a shortened presentation description if its length greatly exceeds the char limit' do
      @presentation_as_attendee.description = 'a' * (char_limit + 10)

      description = display_description(@presentation_as_attendee)
      short_span_description = '<span>' + @presentation_as_attendee.description[0..char_limit] + '</span>'

      assert_includes description, short_span_description, 'Expected output does not include shortened description'
      assert_includes description, '(more)', 'Expected output does not include "(more)"'
    end
  end

  describe '#feedback_content' do
    it 'tests pending...'
  end

  describe '#provide_feedback_button' do
    it 'shows provide feedback button if feedback has not been completed' do
      link_string = provide_feedback_button(@user, @presentation_as_attendee)

      assert link_string.include?('Provide Feedback'), 'Link does not include "Provide Feedback"'
      assert link_string.include?(new_presentation_response_path(@presentation_as_attendee)), 'Link does not include correct path'
    end

    it 'shows disabled feedback button when feedback completed' do
      presentation = create(:presentation)
      create(:participation, user_id: @user.id, presentation_id: presentation.id, is_presenter: false, feedback_provided: true)

      link_string = provide_feedback_button(@user, presentation)

      assert link_string.include?('disabled'), 'Link does not contain "disabled" class'
      assert link_string.include?('Feedback Submitted'), 'Link does not contain "Feedback Submitted"'
    end
  end

  describe '#feedback_button' do
    before do
      @see_feedback_text = 'See Feedback'
      @submitted_text = 'Feedback Submitted'
      @too_early_text = 'Available after Presentation'
      @disabled_css = 'disabled'
    end
    it 'shows disabled button before presentation start time' do
      link_string = feedback_button(@user, @future_presentation_as_presenter)

      refute link_string.include?(@see_feedback_text), "Link contains '#{@see_feedback_text}'"
      refute link_string.include?(@submitted_text), "Link contains '#{@submitted_text}'"
      assert link_string.include?(@disabled_css), "Link does not contain '#{@disabled_css}' css class"
      assert link_string.include?(@too_early_text), "Link does not contain '#{@too_early_text}'"
    end

    it 'does not show any button on presentation#show before presentation start time' do
      params[:controller] = 'presentations'
      params[:action] = 'show'

      link_string = feedback_button(@user, @future_presentation_as_attendee)

      assert link_string.nil?, 'Displaying link when on presentation#show page before presentation start date'
    end

    it 'shows "See Feedback" button if user is presenter' do
      link_string = feedback_button(@user, @presentation_as_presenter)

      assert link_string.include?(@see_feedback_text), "Link does not contain '#{@see_feedback_text}'"
      assert link_string.include?(presentation_responses_path(@presentation_as_presenter)), 'Link does not include correct path'
    end

    it 'shows "See Feedback" button if admin is presenter' do
      link_string = feedback_button(@admin, @presentation_as_admin_presenter)

      assert link_string.include?('See Feedback'), 'Link does not contain "See Feedback"'
      assert link_string.include?(presentation_responses_path(@presentation_as_admin_presenter)), 'Link does not include correct path'
    end

    it 'does not show "See Feedback" button if user is not presenter' do
      link_string = feedback_button(@user, @presentation_as_attendee)

      refute link_string.include?(@see_feedback_text), "Link should not contain '#{@see_feedback_text}' "
    end
  end

  describe '#survey_link_for' do
    it 'renders link to see surveys if presentation already has surveys created' do
      presentation = create(:presentation)
      create(:survey, presentation_id: presentation.id)

      link_text = survey_link_for(presentation)

      assert link_text.include?('See Surveys'), 'Link does not contain "See Surveys"'
      refute link_text.include?('Create Survey'), 'Link contains "Create Survey"'
    end

    it 'renders link to create surveys if presentation has no surveys' do
      presentation = create(:presentation)

      link_text = survey_link_for(presentation)

      assert link_text.include?('Create Survey'), 'Link does not contain "Create Survey"'
      refute link_text.include?('See Surveys'), 'Link contains "See Survyes "'
    end
  end

  describe '#presentation_options' do
    let(:link) { presentation_options(@admin, @presentation_as_attendee) }
    let(:link2) { presentation_options(@user, @future_presentation_as_presenter) }

    it 'returns a link to edit presentation if user is an admin' do
      assert_includes link, edit_presentation_path(@presentation_as_attendee), 'Does not include link to edit presentation'
    end

    it 'returns a link to edit participants if user is an admin' do
      assert_includes link, 'Edit Participants', 'Does not include link to edit participants'
    end

    it 'returns a link to edit surveys if user is an admin' do
      assert_includes link, presentation_surveys_path(@presentation_as_attendee), 'Does not include link to edit surveys'
    end

    it 'returns a link to delete presentation if user is an admin' do
      assert_includes link, 'Delete', 'The word "Delete" is not in the delete link'
      assert_includes link, presentation_path(@presentation_as_attendee), 'Does not include link to delete presentation'
    end

    it 'returns a link to view surveys if user is a presenter' do
      assert_includes link2, presentation_surveys_path(@future_presentation_as_presenter), 'Does not include link to view surveys as a presenter'
    end

    it 'returns nil if user is not an admin or presenter' do
      assert_nil presentation_options(@user, @presentation_as_attendee), 'Expected nil if user is not an admin'
    end
  end

  describe '#presenter_presentation_options' do
    let(:future_link) { presenter_presentation_options(@future_presentation_as_presenter) }
    let(:past_link) { presenter_presentation_options(@presentation_as_presenter) }

    it 'returns a link to view surveys if presentation is in the future' do
      assert_includes future_link, presentation_surveys_path(@future_presentation_as_presenter), 'Does not include link to view surveys as a presenter'
    end

    it 'returns nil if presentation is in the past' do
      assert_nil past_link, 'Returns something other than nil when presentation in the past'
    end
  end

  describe '#participation_table' do
    it 'tests pending...'
  end

  describe '#set_participation_title' do
    it 'returns the singular for a given role if the number of participants equals 1' do
      assert_equal set_participation_title(:presenter, 1), 'presenter', 'Expected method to return "presenter"'
    end

    it 'returns the plural for a given role if the number of participants is not 1' do
      assert_equal set_participation_title(:presenter, 0), 'presenters', 'Expected method to return "presenters"'
      assert_equal set_participation_title(:presenter, 3), 'presenters', 'Expected method to return "presenters"'
    end
  end
end

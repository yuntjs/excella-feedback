require 'test_helper'

class DestroySurveyTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Show' do
    scenario 'admin can view surveys for a presentation' do
      admin = create(:user, :admin)
      presentation = create(:presentation)
      create(:survey, presentation_id: presentation.id)

      login_as(admin, scope: :user)

      visit(root_path)

      within('.navbar-left') do
        click_on('View Presentations')
      end
      click_on(presentation.title)
      click_on('View Surveys')

      assert_equal(presentation_surveys_path(presentation), current_path)
    end

    scenario 'presenter can view surveys for their presentation' do
      presenter = create(:user)
      presentation = create(:presentation, :in_the_future)
      create(:participation, :presenter,
             user_id: presenter.id,
             presentation_id: presentation.id)
      create(:survey, presentation_id: presentation.id)

      login_as(presenter, scope: :user)

      visit(root_path)

      within('.navbar-left') do
        click_on('View Presentations')
      end
      click_on(presentation.title)

      click_on('View Surveys')

      assert_equal(presentation_surveys_path(presentation), current_path)
    end

    scenario 'a presenter cannot view surveys for a presentation where they are an attendee' do
      presenter = create(:user)
      presentation1 = create(:presentation, :in_the_future)
      create(:participation, :presenter,
             user_id: presenter.id,
             presentation_id: presentation1.id)
      create(:survey, presentation_id: presentation1.id)

      presentation2 = create(:presentation, :in_the_future)
      create(:participation,
             user_id: presenter.id,
             presentation_id: presentation2.id)
      create(:survey, presentation_id: presentation2.id)

      login_as(presenter, scope: :user)

      visit(root_path)

      within('.navbar-left') do
        click_on('View Presentations')
      end
      click_on(presentation2.title)

      refute(page.has_content?('See Surveys'))
    end

    scenario 'general participant cannot view surveys' do
      participant = create(:user)
      presentation = create(:presentation, :in_the_future)
      create(:participation,
             user_id: participant.id,
             presentation_id: presentation.id)
      create(:survey, presentation_id: presentation.id)

      login_as(participant, scope: :user)

      visit(root_path)

      within('.navbar-left') do
        click_on('View Presentations')
      end
      click_on(presentation.title)

      refute(page.has_content?('See Surveys'))
    end
  end
end

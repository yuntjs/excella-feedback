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

    scenario 'presenter can view surveys for a presentation' do
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
  end
end

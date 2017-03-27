require 'test_helper'

class EditSurveyTemplateTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Edit' do
    before do
      admin = create :user, :admin
      @survey_template = create(:survey_template)

      login_as(admin, scope: :user)

      visit(survey_template_path(@survey_template))
    end

    scenario 'updates survey_template with new data' do
      click_on('Edit Survey')

      within 'form' do
        fill_in('Name', with: 'Foo')
        fill_in('Title', with: 'Bar')
        click_button('Submit')
      end

      page.must_have_content('Foo')
      page.must_have_content('Bar')
    end

    scenario 'does not update survey_template with invalid data' do
      click_on('Edit Survey')

      within 'form' do
        fill_in('Name', with: nil)
        fill_in('Title', with: nil)
        click_button('Submit')
      end

      page.must_have_content('Warning!')
    end
  end
end

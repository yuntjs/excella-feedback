require "test_helper"

class CreatePresentationTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature "Create" do
    scenario "creates a new presentation if admin" do
      user = create :user, :admin
      login_as(user, scope: :user)

      visit root_path

      click_on "Create New Presentation"

      within ("form") do
        fill_in "Title", with: "Foo Bar"
        fill_in "Location", with: "Over there"
        fill_in "Description", with: "Lorem ipsum"
        click_button "Submit"
      end

      page.must_have_content "Foo Bar"
    end

    scenario "redirects to presentation index if non-admin" do
      user = create :user
      login_as(user, scope: :user)

      visit new_presentation_path

      assert_equal current_path, presentations_path
    end
  end
end

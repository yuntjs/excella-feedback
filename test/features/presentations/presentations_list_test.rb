require "test_helper"

class PresentationsListTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature "Viewing presentations as a general user" do
    before do
      @user = create(:user)
      login_as(@user, scope: :user)

      visit(root_path)

      within("nav") { click_on("View Presentations") }
    end

    scenario "a general user can go to the page with the list of presentations" do
      assert_equal current_path, presentations_path, "Current path is not presentations_path"
    end

    scenario "a general user can only see their own presentations" do
      create_list(:presentation, 10)
      pres = create(:presentation, title: "user's presentation")
      create(:participation, user: @user, presentation: pres)

      expected_rows = 2 # includes table header row

      visit(presentations_path)

      assert page.has_selector?('table tr', count: expected_rows), "Correct number of table rows not present"
    end

    scenario "a general user sees separate tables for sessions where they are presenting and attending" do
      pres_1 = create(:presentation, title: "user's presentation")
      pres_2 = create(:presentation, title: "another presentation")

      create(:participation, user: @user, presentation: pres_1, is_presenter: true)
      create(:participation, user: @user, presentation: pres_2, is_presenter: false)

      visit(presentations_path)

      assert page.has_selector?('table', count: 2), "Two tables are not present on the page"
      assert page.has_content?('As Presenter'), "Presenter header does not show up on page"
      assert page.has_content?('As Attendee'), "Attendee header does not show up on page"
    end

    scenario "a general user cannot see the admin column" do
      pres = create(:presentation)
      create(:participation, user: @user, presentation: pres)

      visit(presentations_path)

      within('table') do
        refute page.has_content? "Admin"
      end
    end
  end

  feature "Viewing presentations as an admin" do
    before do
      admin = create(:user, :admin)
      login_as(admin, scope: :user)

      visit(root_path)

      within("nav") { click_on("View Presentations") }
    end

    scenario "an admin can see all of the presentations" do
      create_list(:presentation, 10)
      expected_rows = 11 # includes table header row

      visit(presentations_path)

      assert page.has_selector?('table tr', count: expected_rows), "Correct number of table rows not present"
    end

    scenario "an admin can see the admin column" do
      within('table') do
        assert page.has_content? "Admin"
      end
    end
  end
end

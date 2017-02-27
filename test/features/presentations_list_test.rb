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
      assert_equal current_path, presentations_path
    end

    scenario "a general user can only see their own presentations" do
      create_list(:presentation, 10)
      pres = create(:presentation, title: "user's presentation")
      create(:participation, user: @user, presentation: pres)
      visit(presentations_path)
      assert page.has_selector?('table tr', count: 2) # 1 presentation + 1 header row
    end

    scenario "a general user cannot see the admin column" do
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
      visit(presentations_path)
      assert page.has_selector?('table tr', count: 11) # 10 presentations + 1 header row
    end

    scenario "an admin can see the admin column" do
      within('table') do
        assert page.has_content? "Admin"
      end
    end
  end
end

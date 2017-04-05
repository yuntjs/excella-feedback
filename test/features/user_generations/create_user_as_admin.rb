require 'test_helper'

class CreateUserAsAdminTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @admin = create :user, :admin
    login_as @admin, scope: :user

    @initial_count = User.count

    visit root_path

    click_on 'Create New User'
  end

  after do
    Warden.test_reset!
  end

  feature 'Creating a user as an admin' do
    scenario 'creating a valid user' do
      fill_in 'Email', with: 'email@example.com'
      fill_in 'First name', with: 'First'
      fill_in 'Last name', with: 'Last'

      click_on 'Create User'

      assert page.has_content?('Success!'), 'Expected page to have flash message with the word "Success!"'
      assert_equal User.count, @initial_count + 1, 'Expected a new user to be created'
    end

    scenario 'creating an invalid user' do
      # Not filling in email
      # Not filling in first name
      # Not filling in last name

      click_on 'Create User'

      assert page.has_content?('Warning!'), 'Expected page to have flash message with the word "Warning!"'
      assert_equal User.count, @initial_count, 'Did not expect the number of users to change'
    end
  end
end

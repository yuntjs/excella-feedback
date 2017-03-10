require 'test_helper'

class SignInTest < Capybara::Rails::TestCase
  feature 'Sign In' do
    before do
      visit root_path
      click_on 'Log In'
    end

    scenario 'has valid content' do
      user = create(:user)

      within ('form') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log In'
      end

      assert_equal current_path, root_path
    end

    scenario 'has invalid password' do
      user = create :user

      within ('form') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password + '_wrong'
        click_button 'Log In'
      end

      assert_equal current_path, new_user_session_path
    end
  end
end

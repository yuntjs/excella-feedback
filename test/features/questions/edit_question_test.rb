require 'test_helper'

class EditQuestionTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

end

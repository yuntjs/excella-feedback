require 'test_helper'

class CreateQuestionTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

end

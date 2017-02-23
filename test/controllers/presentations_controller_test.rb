require "test_helper"

class PresentationsControllerTest < ActionController::TestCase
    # before do
  #   @presentation = Presentation.new(
  #     title: "Test Presentation",
  #     location: "ATX",
  #     date: DateTime.new(2017, 2, 22),
  #     description: "Lorem ipsum",
  #     is_published: true,
  #   )
  # end

  describe "#create" do
    it "when presentation is valid" do
      # Arrange

      # Act
      post "/presentations", params: {
        title: "Test Presentation",
        location: "ATX",
        date: DateTime.new(2017, 2, 22),
        description: "Lorem ipsum",
        is_published: true
      }
      # Assert
      assert_redirected_to "/presentations", "Create method unsuccessful, no redirect to presentations_path"
    end

  end

end

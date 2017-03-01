require "test_helper"

class ResponsesControllerTest < ActionController::TestCase
  include FactoryGirl::Syntax::Methods

  describe "#create" do
    it "should require neccesary validators" do
      response = Response.new
      assert_not response.valid?
      assert_equal [:question, :user, :question_id, :user_id, :value], response.errors.keys
    end

    # it "should only allow a user to save a response to a question once" do
    #   user = create(:user)
    #   question = create(:question)
    #   byebug
    #   response1 = create(:response, user_id: user.id, question_id: question.id)
    #   byebug
    #   response2 = create(:response, user_id: user.id, question_id: question.id)
    #   byebug
    #   assert_not response2.valid?, "able to create response with same user_id and question_id"
    # end
  end
end

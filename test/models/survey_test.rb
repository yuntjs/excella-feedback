require "test_helper"
include FactoryGirl::Syntax::Methods

describe Survey do
  before do
    @survey = create(:survey)
  end

  describe "#order_questions" do
    it "orders questions from 0 to n" do
      question3 = create(:question, survey_id: @survey.id, order:2)
      question1 = create(:question, survey_id: @survey.id, order:0)
      question2 = create(:question, survey_id: @survey.id, order:1)

      expected_order = [question1, question2, question3]
      actual_order = @survey.order_questions

      assert_equal expected_order, actual_order, "Array not ordered correctly"
    end
  end
end

require 'test_helper'
include FactoryGirl::Syntax::Methods

describe Survey do
  before do
    @survey = create(:survey)
  end

  describe "#position_questions" do
    it "orders questions from 0 to n" do
      question3 = create(:question, survey_id: @survey.id, position:3)
      question1 = create(:question, survey_id: @survey.id, position:1)
      question2 = create(:question, survey_id: @survey.id, position:2)

      expected_position= [question1, question2, question3]
      actual_position= @survey.position_questions

      assert_equal expected_position, actual_position, "Array not positioned correctly"
    end
  end
end

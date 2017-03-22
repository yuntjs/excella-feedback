require "test_helper"

describe QuestionTemplate do
  let(:question_template) { QuestionTemplate.new }

  it "must be valid" do
    value(question_template).must_be :valid?
  end
end

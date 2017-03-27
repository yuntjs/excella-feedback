require 'test_helper'

describe QuestionTemplate do
  before do
    @question_template = create(:question_template, :text, :required)
  end

  it 'must be valid' do
    value(@question_template).must_be :valid?
  end
end

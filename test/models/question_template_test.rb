require 'test_helper'

describe QuestionTemplate do
  # let(:question_template) { QuestionTemplate.new }
  before do
    @question_template = create(:question_template)
  end

  it 'must be valid' do
    value(@question_template).must_be :valid?
  end
end

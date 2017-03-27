require 'test_helper'

describe SurveyTemplate do
  before do
    @survey_template = create(:survey_template)
  end

  it 'must be valid' do
    value(@survey_template).must_be :valid?
  end
end

require 'test_helper'

describe SurveyTemplate do
  let(:survey_template) { SurveyTemplate.new }

  it 'must be valid' do
    value(survey_template).must_be :valid?
  end
end

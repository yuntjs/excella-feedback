require "test_helper"
include FactoryGirl::Syntax::Methods

describe Presentation do

  before do
    @presentation = build(:presentation)
  end

  it 'accepts a valid presentation' do
    result = @presentation.valid?

    assert result, "Valid presentation was considered invalid"
  end

  it 'rejects a presentation without a title' do
    @presentation.title = nil
    result = @presentation.valid?

    refute result, "Accepted presentation with invalid title"
  end

  it 'rejects a presentation without a date' do
    @presentation.date = nil
    result = @presentation.valid?

    refute result, "Accepted presentation with invalid date"
  end

  it 'rejects a presentation without a location' do
    @presentation.location = nil
    result = @presentation.valid?
    
    refute result, "Accepted presentation with invalid location"
  end

end

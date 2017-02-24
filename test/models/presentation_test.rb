require "test_helper"
include FactoryGirl::Syntax::Methods

describe Presentation do

  before do
    @presentation = build(:presentation)
  end

  it 'accepts a valid presentation' do
    # Arrange

    # Act
    result = @presentation.valid?

    # Assert
    assert result, "Valid presentation was considered invalid"
  end

  it 'rejects a presentation without a title' do
    # Arrange
    @presentation.title = nil

    # Act
    result = @presentation.valid?

    # Assert
    refute result, "Accepted presentation with invalid title"
  end

  it 'rejects a presentation without a date' do
    # Arrange
    @presentation.date = nil

    # Act
    result = @presentation.valid?

    # Assert
    refute result, "Accepted presentation with invalid date"
  end

  it 'rejects a presentation without a location' do
    # Arrange
    @presentation.location = nil

    # Act
    result = @presentation.valid?

    # Assert
    refute result, "Accepted presentation with invalid location"
  end

end

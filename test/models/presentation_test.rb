require 'test_helper'

describe Presentation do
  before do
    @presentation = create(:presentation)
  end

  it 'accepts a valid presentation' do
    result = @presentation.valid?

    assert result, 'Valid presentation was considered invalid'
  end

  it 'rejects a presentation without a title' do
    @presentation.title = nil

    result = @presentation.valid?

    refute result, 'Accepted presentation with invalid title'
  end

  it 'rejects a presentation without a date' do
    @presentation.date = nil

    result = @presentation.valid?

    refute result, 'Accepted presentation with invalid date'
  end

  it 'rejects a presentation without a location' do
    @presentation.location = nil

    result = @presentation.valid?

    refute result, 'Accepted presentation with invalid location'
  end

  describe '#description_short' do
    before do
      @presentation = create(:presentation, :long_description)
    end

    it 'returns a shortened version of the description with ellipses at the end' do
      assert_equal @presentation.description_short(30), 'description description...'
    end

    it 'raises an error if argument is not an integer' do
      assert_raises(ArgumentError) { @presentation.description_short('a') }
    end

    it 'raises an error if argument is less than 1' do
      assert_raises(ArgumentError) { @presentation.description_short(-1) }
    end
  end
end

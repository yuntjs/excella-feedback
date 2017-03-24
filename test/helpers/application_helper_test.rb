require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  before do
    @text_question = create(:question, :text, :required)
    @number_question = create(:question, :number, :required)

    @text_response = build(:response, :text, question_id: @text_question.id)
    @number_response = build(:response, :number, question_id: @number_question.id)

    @error_class = 'has-error'

    @invalid_text_response = build(:response, :text, question_id: @text_question.id)
    @invalid_number_response = build(:response, :number, question_id: @number_question.id)

    @invalid_text_response.errors.add(:require_question, :unique_response)
    @invalid_number_response.errors.add(:require_question, :unique_response)
  end

  #
  # Test for #error_class
  # Tested with a response object, but should work for any model instance
  #
  describe '#error_class' do
    it 'returns a css class as a string when object has an error' do
      text_response = error_class(@invalid_text_response)
      number_response = error_class(@invalid_number_response)

      assert_equal text_response, @error_class, 'Text response with error does not return correct css error class.'
      assert_equal number_response, @error_class, 'Number response with error does not return correct css error class'
    end

    it 'returns a css class as a string when object has error & attribute is provided' do
      text_response = error_class(@invalid_text_response, :require_question)
      number_response = error_class(@invalid_number_response, :require_question)

      assert_equal text_response, @error_class, 'Text response with error does not return correct css error class.'
      assert_equal number_response, @error_class, 'Number response with error does not return correct css error class'
    end

    it 'returns an empty string when response does not contain an error' do
      text_response = error_class(@text_question)
      number_response = error_class(@number_question)

      assert text_response.empty?, "Does not return an empty string for a valid text response. Got: #{text_response}"
      assert number_response.empty?, "Does not return an empty string for a valid number response. Got: #{number_response}"
    end

    it 'returns an empty string when response does not contain an error & attribute is provided' do
      text_response = error_class(@text_question, :require_question)
      number_response = error_class(@number_question, :require_question)

      assert text_response.empty?, "Does not return an empty string for a valid text response. Got: #{text_response}"
      assert number_response.empty?, "Does not return an empty string for a valid number response. Got: #{number_response}"
    end
  end

  #
  # Test for #error_class
  # Tested with a response object, but should work for any model instance
  #
  describe '#error_class' do
    it 'returns a css class as a string when object has an error' do
      text_response = error_class(@invalid_text_response)
      number_response = error_class(@invalid_number_response)

      assert_equal text_response, @error_class, 'Text response with error does not return correct css error class.'
      assert_equal number_response, @error_class, 'Number response with error does not return correct css error class'
    end

    it 'returns an empty string when response does not contain an error' do
      text_response = error_class(@text_question)
      number_response = error_class(@number_question)

      assert text_response.empty?, "Does not return an empty string for a valid text response. Got: #{text_response}"
      assert number_response.empty?, "Does not return an empty string for a valid number response. Got: #{number_response}"
    end
  end

  #
  # Test for #error_messages
  # Tested with a response object, but should work for any model instance
  #
  describe '#error_messages' do
    it 'contains css error class' do
      text_response = error_messages(@invalid_text_response)
      number_response = error_messages(@invalid_number_response)

      assert text_response.include?(@error_class), 'Invalid text error message does not contain correct error class'
      assert number_response.include?(@error_class), 'Invalid number error message does not contain error class'
    end

    it 'returns nil for a response without errors' do
      text_response = error_messages(@text_response)
      number_response = error_messages(@number_response)

      assert text_response.nil?, 'Valid text response returned value other than nil'
      assert number_response.nil?, 'Valid number response returned value other than nil'
    end
  end

  #
  # Testing #render_list
  #
  describe '#render_list' do
    it 'returns each message in an array as a <li> element' do
      msg_array = ['Hello World', 'Hola Mundo', 'Dlrow Olleh', 'Odnum Aloh']

      raw_string = render_list(msg_array)
      list_length = raw_string.split('</li>').length

      assert raw_string.include?('<li>'), 'does not create any <li> elements'
      assert_equal msg_array.length, list_length, 'does not create <li> for each message.'
    end

    it 'works with error messages' do
      text_errors = @invalid_text_response.errors.full_messages
      number_errors = @invalid_number_response.errors.full_messages

      raw_text_string = render_list(text_errors)
      raw_number_string = render_list(number_errors)

      text_list_length = raw_text_string.split('</li>').length
      number_list_length = raw_number_string.split('</li>').length

      assert_equal text_errors.length, text_list_length, 'Text errors do not match resulting list'
      assert_equal number_errors.length, number_list_length, 'Number errors do not match resulting list'
    end
  end

end

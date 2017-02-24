require "test_helper"
include FactoryGirl::Syntax::Methods

describe User do

  before do
    @user = build(:user)
  end

  it 'requires a user to be valid' do
    # Arrange

    # Act
    result = @user.valid?

    # Assert
    assert result, "Valid user was considered invalid"
  end

  it 'rejects a user without a first name' do
    # Arrange
    @user.first_name = nil

    # Act
    result = @user.valid?

    # Assert
    refute result, "Accepted user with invalid first name"
  end

  it 'rejects a user without a last name' do
    # Arrange
    @user.last_name = nil

    # Act
    result = @user.valid?

    # Assert
    refute result, "Accepted user with invalid last name"
  end

end

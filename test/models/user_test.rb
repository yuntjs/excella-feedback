require "test_helper"

describe User do
  before do
    @user = User.create(
      email: "nicholas.oki@excella.com",
      password: "testing",
      password_confirmation: "testing",
      first_name: "Nick",
      last_name: "Oki"
    )
  end

  # Happy Path
  it 'requires a user to be valid' do
    # Arrange

    # Act
    result = @user.valid?
    # Assert
    assert result, "User is not valid"
  end

  # Nil Value
  it 'requires a user to be valid' do
    # Arrange
    @user.first_name = nil
    # Act
    result = @user.valid?
    # Assert
    refute result, "first_name cannot be nil"
  end

end

require "test_helper"
include FactoryGirl::Syntax::Methods

describe User do
  before do
    @user = build(:user)
  end

  it "requires a user to be valid" do
    result = @user.valid?

    assert result, "Valid user was considered invalid"
  end

  it "rejects a user without a first name" do
    @user.first_name = nil

    result = @user.valid?

    refute result, "Accepted user with invalid first name"
  end

  it "rejects a user without a last name" do
    @user.last_name = nil

    result = @user.valid?

    refute result, "Accepted user with invalid last name"
  end
end

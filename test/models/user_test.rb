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

  describe "#presentations_as_presenter" do

    let(:pres) { create(:presentation) }

    it "gets all a user's presentations where they are the presenter" do
      create(:participation, user: @user, presentation: pres, is_presenter: true)
      assert_equal @user.presentations_as_presenter, [pres], "Presenter cannot see their presentations"
    end

    it "does not include any presentations where the user is not the presenter" do
      pres_2 = create(:presentation)
      create(:participation, user: @user, presentation: pres, is_presenter: true)
      create(:participation, user: @user, presentation: pres_2, is_presenter: false)
      assert_equal @user.presentations_as_presenter, [pres], "Presenter sees more than their presentations"
    end

    it "returns an empty ActiveRecord relation if the user is never a presenter" do
      assert_equal @user.presentations_as_presenter, []
    end

  end

end

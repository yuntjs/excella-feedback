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

  describe "#presentations_as" do

    let(:pres) { create(:presentation) }

    it "gets all of a user's presentations where they are the presenter" do
      create(:participation, user: @user, presentation: pres, is_presenter: true)
      assert_equal @user.presentations_as(:presenter), [pres]
    end

    it "gets all of user's presentations where they are the attendee" do
      create(:participation, user: @user, presentation: pres, is_presenter: false)
      assert_equal @user.presentations_as(:attendee), [pres]
    end

    it "does not include any presentations where the user is not the presenter if :presenter is passed as an argument" do
      pres_2 = create(:presentation)
      create(:participation, user: @user, presentation: pres, is_presenter: true)
      create(:participation, user: @user, presentation: pres_2, is_presenter: false)
      assert_equal @user.presentations_as(:presenter), [pres]
    end

    it "does not include any presentations where the user is not an attendee if :attendee is passed as an arguent" do
      pres_2 = create(:presentation)
      create(:participation, user: @user, presentation: pres, is_presenter: true)
      create(:participation, user: @user, presentation: pres_2, is_presenter: false)
      assert_equal @user.presentations_as(:attendee), [pres_2]
    end

    it "returns an empty relation if a role other than :presenter and :attendee is passed" do
      assert_equal @user.presentations_as(:guest), []
    end

    it "returns an empty relation if nil is passed in" do
      assert_equal @user.presentations_as(nil), []
    end

  end

end

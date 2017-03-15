require 'test_helper'

class PresentationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @params = {
      title: 'Test Presentation',
      location: 'ATX',
      date: DateTime.new(2017, 2, 22),
      description: 'Lorem ipsum',
      is_published: true
    }
  end

  describe '#index' do
    it 'gets all presentations if you are an admin' do
      admin = create :user, :admin
      presentation = create :presentation
      sign_in admin

      get :index

      assert_equal Presentation.all, [presentation], 'Did not return presentations'
    end

    it 'gets only presentations for which a non-admin user is a participant' do
      user = create :user
      pres1 = create :presentation
      pres2 = create :presentation

      create :participation, user: user, presentation: pres1

      sign_in user

      get :index

      assert_equal user.presentations, [pres1], 'Returned presentation for which the user is not a participant'
    end
  end

  describe '#create' do
    it 'creates a new presentation' do
      admin = create :user, :admin
      create :presentation

      sign_in admin

      assert Presentation.first.valid?, "Presentation was not created"
    end

    it 'redirects to index page if logged in' do
      user = create :user
      sign_in user

      post :create, params: @params

      assert_redirected_to presentations_path, 'No redirect to presentations_path'
    end

    it 'redirects to sign-in page if a user is not signed in' do
      post :create, params: @params

      assert_redirected_to new_user_session_path, 'Did not redirect to sign-in page'
    end
  end

  describe '#update' do
    it 'should allow admins to update presentations' do
      admin = create :user, :admin
      presentation = create :presentation

      updated_location = 'Kitchen'
      updated_description = 'Free food'

      sign_in admin

      patch :update, params: { id: presentation.id, presentation: { location: updated_location, description: updated_description } }
      presentation.reload

      assert_equal [updated_location, updated_description], [presentation.location, presentation.description], 'Update method unsuccessful. Values do not match'
      assert_redirected_to presentation_path(presentation.id), 'Redirect to presentations_path failed'
    end
  end

  describe '#destroy' do
    it 'should allow admins to delete presentations' do
      admin = create :user, :admin
      presentation = create :presentation

      sign_in admin

      delete :destroy, params: { id: presentation.id }
      assert_equal Presentation.count, 0, 'Presentation was not deleted'
    end
  end
end

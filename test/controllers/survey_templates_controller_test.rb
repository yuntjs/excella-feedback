require 'test_helper'

class SurveyTemplatesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  describe '#index' do
    it 'gets all survey_templates if you are an admin' do
      admin = create :user, :admin
      survey_template = create :survey_template

      sign_in(admin)

      get(:index)

      assert_equal(SurveyTemplate.all, [survey_template], 'Did not return survey_templates')
    end
  end

  describe '#show' do
    it 'gets specific survey_template if you are an admin' do
      admin = create :user, :admin
      survey_template = create :survey_template

      sign_in(admin)

      get(:show, params: { id: survey_template.id })
      survey_template_instance = assigns(:survey_template)

      assert_equal(survey_template_instance, survey_template, 'Did not return survey_templates')
    end
  end

  describe '#create' do
    it 'creates a new survey_template' do
      admin = create(:user, :admin)
      create(:survey_template)

      sign_in(admin)

      assert(SurveyTemplate.first.valid?, 'SurveyTemplate was not created')
    end

    it 'redirects to sign-in page if a user is not signed in' do
      post(:create)

      assert_redirected_to(new_user_session_path, 'Did not redirect to sign-in page')
    end

    it 'does not create a new survey_template with invalid params' do
      post(:create, params: { title: nil, name: nil })

      assert(SurveyTemplate.first.nil?, 'SurveyTemplate was created with invalid params')
    end
  end

  describe '#update' do
    it 'should allow admins to update survey_template' do
      admin = create :user, :admin
      survey_template = create :survey_template

      updated_title = 'New Title'
      updated_name = 'New Name'

      sign_in admin

      patch :update, params: { id: survey_template.id, survey_template: { title: updated_title, name: updated_name } }
      survey_template.reload

      assert_equal [updated_title, updated_name], [survey_template.title, survey_template.name], 'Update method unsuccessful. Values do not match'
      assert_redirected_to survey_template_path(survey_template.id), 'Redirect to survey_template_path failed'
    end

    it 'should not update with invalid params' do
      admin = create :user, :admin
      survey_template = create :survey_template

      updated_title = ''
      updated_name = ''

      sign_in admin

      patch :update, params: { id: survey_template.id, survey_template: { title: '', name: '' } }
      survey_template.reload

      assert_equal(SurveyTemplate.first, survey_template, 'SurveyTemplate was not created')
    end
  end

  describe '#destroy' do
    it 'should allow admins to delete presentations' do
      admin = create :user, :admin
      survey_template = create :survey_template

      sign_in admin

      delete :destroy, params: { id: survey_template.id }
      assert_equal SurveyTemplate.count, 0, 'SurveyTemplate was not deleted'
    end
  end
end

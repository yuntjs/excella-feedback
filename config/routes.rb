Rails.application.routes.draw do
  root 'static#home'
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :presentations do
    resources :participations, only: [:update]
    resources :surveys do
      resources :questions, except: [:index]
    end
    resources :responses, only: [:index, :new, :create]
  end

  resources :survey_templates do
    resources :question_templates
  end
end

Rails.application.routes.draw do
  root 'static#home'
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :presentations do
    resources :participations, only: [:update]
    resources :surveys do
      resources :questions
    end
    resources :responses, only: [:index, :new, :create]
    resources :survey_generations, only: [:create]
  end

  resources :survey_templates do
    resources :question_templates
  end

  resources :user_generations, only: [:new, :create]
end

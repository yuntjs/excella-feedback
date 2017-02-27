Rails.application.routes.draw do
  # Root path
  root 'static#home'

  # Devise routes, controller override
  devise_for :users, :controllers => { registrations: 'registrations' }

  # Routes for Presentation, Survey, and Question
  resources :presentations do
    resources :surveys do
      resources :questions
    end
  end

end

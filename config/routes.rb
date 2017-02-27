Rails.application.routes.draw do
  # Root path
  root 'static#home'

  # Devise routes, controller override
  devise_for :users, :controllers => { registrations: 'registrations' }

  # Routes for presentations
  resources :presentations do
    resources :surveys do
      resources :questions
    end

    resources :responses
  end

end

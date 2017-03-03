Rails.application.routes.draw do
  # Root path
  root 'static#home'
  get '/nopresentations', to: 'presentations#nopresentations'
  # Devise routes, controller override
  devise_for :users, :controllers => { registrations: 'registrations' }

  # Routes for Presentation, Survey, and Question
  resources :presentations do
    resources :surveys do
      resources :questions
    end

    resources :responses
  end

  resources :participations

end

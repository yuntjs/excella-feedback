Rails.application.routes.draw do
  root 'static#home'
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :presentations do
    resources :participations
    resources :surveys do
      resources :questions
    end

    resources :responses
  end
end

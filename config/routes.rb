Rails.application.routes.draw do
  # Root path
  root 'static#home'

  # Devise routes, controller override
  devise_for :users, :controllers => { registrations: 'registrations' }

  # Routes for Presentation
  resources :presentations do
    # Routes for Participation
    post 'create_participation'
    get 'edit_participation'
    put 'update_participation'
    delete 'destroy_participation'

    # Routes for Survey and Question
    resources :surveys do
      resources :questions
    end
  end

end

Rails.application.routes.draw do
  # Root path
  root 'static#home'

  # Devise routes, controller override
  devise_for :users, :controllers => { registrations: 'registrations' }

  # Routes for Presentation
  resources :presentations do
    # Routes for Participation
    post 'add_participation'
    get 'edit_participation'
    put 'update_participation'
    delete 'remove_participation'

    # Routes for Survey and Question
    resources :surveys do
      resources :questions
    end
  end

end

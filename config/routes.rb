Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'

  resource :attachments, only: [:destroy]

  resources :questions do
    resources :answers do
      member { patch :set_the_best }
    end
  end
end

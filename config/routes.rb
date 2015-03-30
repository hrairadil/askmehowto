Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :attachments, only: [:destroy]
    resources :answers do
      resources :attachments, only: [:destroy]
      member { patch :set_the_best }
    end
  end
end

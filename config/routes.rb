Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'

  resources :attachments, only: [:destroy]

  resources :questions do

    member { patch :vote_up }
    member { patch :vote_down }

    resources :answers, only: [:create, :update, :destroy] do
      member { patch :set_the_best }
      member { patch :vote_up }
      member { patch :vote_down }
    end
  end
end

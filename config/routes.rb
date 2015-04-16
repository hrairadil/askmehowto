Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'

  resources :attachments, only: [:destroy]

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :unvote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, only: [:create, :update, :destroy], concerns: :votable, shallow: true do
      member { patch :set_the_best }
    end
  end
end

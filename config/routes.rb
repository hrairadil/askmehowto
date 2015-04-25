Rails.application.routes.draw do

  #get 'comments/create'

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

  concern :commentable do |options|
    resources :comments, options
  end

  resources :questions, concerns: :votable  do
    concerns :commentable, only: :create, defaults: { commentable: 'questions' }

    resources :answers, only: [:create, :update, :destroy], concerns: :votable, shallow: true do
      #concerns :commentable, only: :create, defaults: { commentable: 'answers' }
      member { patch :set_the_best }
    end
  end
end

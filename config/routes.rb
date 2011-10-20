Irekia::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => 'users', :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users do
    resources :follows
    collection do
      get 'intro'
    end
    member do
      get 'connect'
      get 'questions'
      get 'proposals'
      get 'actions'
      get 'followings'
      get 'agenda'
      get 'settings'
    end
  end

  namespace :admin do
    match '/' => 'admin#index'
    match '/moderation' => 'moderation#index'
    match '/moderation/validate_all/:type' => 'moderation#validate_all', :as => :moderate_all
    resources :users
    # resources :contents
    resources :proposals,      :controller => 'contents',       :type => 'Proposal'
    resources :arguments,      :controller => 'contents',       :type => 'Argument'
    resources :questions,      :controller => 'contents',       :type => 'Question'
    resources :answers,        :controller => 'contents',       :type => 'Answer'
    resources :news,           :controller => 'contents',       :type => 'News'
    resources :polls,          :controller => 'contents',       :type => 'Poll'
    resources :poll_answers,   :controller => 'contents',       :type => 'PollAnswer'
    resources :events,         :controller => 'contents',       :type => 'Event'
    resources :tweets,         :controller => 'contents',       :type => 'Tweet'
    resources :photos,         :controller => 'contents',       :type => 'Photo'
    # resources :participations
    resources :comments,       :controller => 'participations', :type => 'Comment'
    resources :arguments,      :controller => 'participations', :type => 'Argument'
    resources :likes,          :controller => 'participations', :type => 'Like'
    resources :answer_request, :controller => 'participations', :type => 'AnswerRequest'
  end

  resources :areas do
    resources :follows
    member do
      get 'actions', :path => 'actions(/:type)(.:format)'
      get 'questions'
      get 'proposals'
      get 'agenda'
      get 'team'
    end
  end

  resources :politicians do
    resources :follows
    member do
      get 'actions'
      get 'questions'
      get 'proposals'
      get 'agenda'
    end
  end

  resources :proposals,    :controller => 'contents', :type => 'Proposal'
  resources :questions,    :controller => 'contents', :type => 'Question'
  resources :answers,      :controller => 'contents', :type => 'Answer'
  resources :news,         :controller => 'contents', :type => 'News'
  resources :polls,        :controller => 'contents', :type => 'Poll'
  resources :poll_answers, :controller => 'contents', :type => 'PollAnswer'
  resources :events,       :controller => 'contents', :type => 'Event'
  resources :tweets,       :controller => 'contents', :type => 'Tweet'
  resources :photos,       :controller => 'contents', :type => 'Photo'

  resources :demo

  resources :arguments,    :controller => 'participations', :type => 'Argument'
  resources :comments,     :controller => 'participations', :type => 'Comment'

  resource :search do
    member do
      get :contents
      get :politicians
      get :citizens
    end
  end

  root :to => "home#index"

  match '/in_development', :to => 'application#in_development'
  match '*a', :to => 'application#render_not_found'
end

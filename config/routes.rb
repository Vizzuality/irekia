Irekia::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

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
    member do
      get 'actions'
      get 'questions'
      get 'proposals'
      get 'agenda'
      get 'team'
    end
  end

  resources :politics do
    member do
      get 'actions'
      get 'questions'
      get 'proposals'
      get 'agenda'
    end
  end

  resources :users
  resources :proposals,    :controller => 'contents', :type => 'Proposal'
  resources :arguments,    :controller => 'contents', :type => 'Argument'
  resources :questions,    :controller => 'contents', :type => 'Question'
  resources :answers,      :controller => 'contents', :type => 'Answer'
  resources :news,         :controller => 'contents', :type => 'News'
  resources :polls,        :controller => 'contents', :type => 'Poll'
  resources :poll_answers, :controller => 'contents', :type => 'PollAnswer'
  resources :events,       :controller => 'contents', :type => 'Event'
  resources :tweets,       :controller => 'contents', :type => 'Tweet'
  resources :photos,       :controller => 'contents', :type => 'Photo'

  resources :comments,     :controller => 'participations', :type => 'Comment'

  match '/search' => 'search#show'

  root :to => "home#index"
end

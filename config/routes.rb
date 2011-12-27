Irekia::Application.routes.draw do

  if Rails.env.development?
    mount ModerationMailer::Preview => 'mail_view'
  end

  scope '(:locale)' do

    localized do

      devise_for :users, :controllers => {
        :sessions => 'sessions',
        :registrations => 'users',
        :omniauth_callbacks => 'users/omniauth_callbacks'
      }

      resources :users, :except => [:index] do
        resources :follows
        collection do
          get 'intro'
        end
        member do
          get :connect
          get :questions
          get :proposals
          get :actions
          get :followings
          get :agenda
          get :settings
        end
      end

      namespace :admin do
        match '/' => 'admin#index'
        match '/moderation' => 'moderation#index'
        match '/moderation/validate_all/:type' => 'moderation#validate_all', :as => :moderate_all
        resources :users
        resources :proposals,       :controller => 'contents',       :type => 'Proposal'
        resources :questions,       :controller => 'contents',       :type => 'Question'
        resources :answers,         :controller => 'contents',       :type => 'Answer'
        resources :news,            :controller => 'contents',       :type => 'News'
        resources :events,          :controller => 'contents',       :type => 'Event'
        resources :tweets,          :controller => 'contents',       :type => 'Tweet'
        resources :status_messages, :controller => 'contents',       :type => 'Tweet'
        resources :photos,          :controller => 'contents',       :type => 'Photo'
        resources :comments,        :controller => 'participations', :type => 'Comment'
        resources :arguments,       :controller => 'participations', :type => 'Argument'
        resources :votes,           :controller => 'participations', :type => 'Vote'
        resources :answer_requests, :controller => 'participations', :type => 'AnswerRequest'
      end

      resources :areas do
        member do
          get :actions
          get :questions
          get :proposals
          get :agenda
          get :team
        end
        resources :follows do
          collection do
            get 'button'
          end
        end
      end

      resources :politicians do
        member do
          get :actions
          get :questions
          get :proposals
          get :agenda
          get :detail
        end
        resources :follows do
          collection do
            get 'button'
          end
        end
      end

      resources :proposals,       :controller => 'contents', :type => 'Proposal' do
        resources :shares
      end
      resources :questions,       :controller => 'contents', :type => 'Question' do
        resources :shares
      end
      resources :answers,         :controller => 'contents', :type => 'Answer' do
        resources :shares
      end
      resources :news,            :controller => 'contents', :type => 'News' do
        resources :shares
      end
      resources :events,          :controller => 'contents', :type => 'Event' do
        resources :shares
      end
      resources :tweets,          :controller => 'contents', :type => 'Tweet' do
        resources :shares
      end
      resources :status_messages, :controller => 'contents', :type => 'StatusMessage' do
        resources :shares
      end
      resources :photos,          :controller => 'contents', :type => 'Photo' do
        resources :shares
      end
      resources :videos,          :controller => 'contents', :type => 'Video' do
        resources :shares
      end
      resources :images, :only => [:create, :update, :destroy]

      resources :demo
      match 'user_publish', :to => 'demo#user_publish'
      match 'politician_publish', :to => 'demo#politician_publish'
      match 'event_edit', :to => 'demo#event_edit'

      resources :arguments,       :controller => 'participations', :type => 'Argument'
      resources :votes,           :controller => 'participations', :type => 'Vote'
      resources :comments,        :controller => 'participations', :type => 'Comment'
      resources :answer_requests, :controller => 'participations', :type => 'AnswerRequest'

      resource :search do
        member do
          get :contents
          get :areas
          get :politicians
          get :politicians_and_areas
          get :citizens
        end
      end

      authenticated :user do
        root :to => "users#show"
      end
      root :to                 => 'home#index'

      match '/agenda'          => 'home#agenda'
      match '/nav_bar_buttons' => 'home#nav_bar_buttons'
      post  '/change_locale'   => 'home#change_locale'

    end

    match '/in_development', :to => 'application#in_development'
    match '*a',              :to => 'application#render_not_found'

  end

end

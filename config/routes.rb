Irekia::Application.routes.draw do
  resources :areas
  resources :politics
  resources :users
  resources :proposals,    :controller => 'contents', :type => 'Proposal'
  resources :arguments,    :controller => 'contents', :type => 'Argument'
  resources :questions,    :controller => 'contents', :type => 'Question'
  resources :answers,      :controller => 'contents', :type => 'Answer'
  resources :news,         :controller => 'contents', :type => 'News'
  resources :polls,        :controller => 'contents', :type => 'Poll'
  resources :poll_answers, :controller => 'contents', :type => 'PollAnswer'
  resources :search, :only => :show
end

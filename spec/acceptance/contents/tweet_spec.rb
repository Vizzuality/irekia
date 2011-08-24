#encoding: UTF-8

require 'spec_helper'

feature "Tweet page" do
  background do
    validate_all_not_moderated
    @tweet = Tweet.first
  end

  scenario "shows a tweet from a user" do
    visit tweet_path(@tweet)

    within '#tweet' do
      page.should have_css 'h1', :text => 'Saliendo para el Euskal Encounter. Muchas ganas de asistir la charla de @alorza sobre Open Data'
      page.should have_css '.author', :text => /Twitteado por María González Pérez hace menos de 1 minuto/
      page.should have_link 'María González Pérez'
    end
  end

  scenario "has a sidebar with sharing links and the list of last tweets of that user" do
    visit tweet_path(@tweet)

    within '.sharing_links' do
      page.should have_link 'Mail'
      page.should have_link 'Twitter'
      page.should have_link 'Facebook'
    end
    within '.last_tweets' do
      page.should have_css 'h3', :text => 'Últimos tweets de María'
      page.should have_css 'ul li p.tweet', :text => 'Preparando lo de mañana en el Euskal Encounter'
      page.should have_css 'ul li', :text => 'Vuelta de vacaciones. Grr.'
      page.should have_css 'ul li', :text => '#dearlazyweb, ¿un restaurante en Puerto de Santa María?'
      page.should have_css 'ul li span.when', :text => /hace menos de 1 minuto/, :count => 3
      page.should have_link '@magope'
    end
  end

end
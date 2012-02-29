#encoding: UTF-8
require 'spec_helper'

feature 'Contents' do

  scenario 'should have a detail page for news' do

    news = News.where("slug <> ''").first
    visit news_path(news)

    page.should have_content 'Noticia'
    page.should have_content news.title
    page.should have_css 'iframe', :src => news.iframe_url

    strip_tags(news.body).split("\n").select{|p| p.present?}.each do |paragraph|
      page.should have_content paragraph
    end

    page.should have_content 'Descargas'
    page.should have_css 'ul.tabs'

    page.should have_content 'Tags'
    page.should have_css 'ul.tags li a.content'

    page.should have_content 'Contenidos similares'
    page.should have_css 'ul.related li a'
  end

  scenario 'should have a detail page for event' do
    event = Event.first
    visit event_path(event)

    page.should have_content 'Evento'
    page.should have_content event.title

    strip_tags(event.body).split("\n").select{|p| p.present?}.each do |paragraph|
      page.should have_content paragraph.strip.gsub(/  /, ' ')
    end

    page.should have_content 'Tags'
    page.should have_css 'ul.tags li a.content'

    page.should have_content 'Localización del evento'
    page.should have_css 'ul.location'

    page.should have_content 'Otros eventos de este área'
    page.should have_css 'ul.previously li a'
  end

  scenario 'should have a detail page for question' do
    question = Question.first
    visit question_path(question)

    page.should have_content 'Pregunta'
    page.should have_content question.question_text

    page.should have_content 'Tags'
    page.should have_css 'ul.tags li a.content'

    page.should have_content 'Contestada por'
    page.should have_css 'ul.people li a.name'

    page.should have_content 'Otras preguntas similares'
  end

  scenario 'should have a detail page for proposal' do
    proposal = Proposal.first
    visit proposal_path(proposal)


    page.should have_content 'Propuesta'
    page.should have_content proposal.title

    page.should have_content '80% en contra (5 votos) '
    page.should have_button 'Estoy en contra'
    page.should have_button 'Estoy a favor'

    within 'div.proposal.in_favor' do
      page.should have_content 'Argumentos a favor (2)'
      page.should have_content 'Me parece una idea muy buena. Menos mal que alguien se preocupa por repoblar los bosques y que no se quede en meras intenciones.'
      page.should have_content 'Estoy totalmente de acuerdo con estas iniciativas. Es todo un ejemplo a seguir y esperemos tomen nota el resto de organismos autónomos y así recuperar los bosques españoles.'
      page.should have_button 'Añadir'
    end

    within 'div.proposal.against' do
      page.should have_content 'Argumentos en contra (1)'
      page.should have_content 'Es absurdo preocuparnos de los bosques con la que nos está cayendo actualmente. Deberíamos centrarnos mas en cosas como la vivienda y el paro que en repoblar bosques!!!'
      page.should have_button 'Añadir'
    end

    page.should have_content 'Tags'
    page.should have_css 'ul.tags li a.content'

  end

  scenario 'should have a detail page for photo' do
    photo = Photo.first
    visit photo_path(photo)

    page.should have_content photo.title
    page.should have_css 'img', :src => photo.content_url
    page.should have_content photo.description

    page.should have_content 'Tags'
    page.should have_css 'ul.tags li a.content'
  end

  scenario 'should have a detail page for tweet' do
    tweet = Tweet.first
    visit tweet_path(tweet)

    page.should have_content tweet.message

    page.should have_content 'Tweets anteriores de Aitana'
    page.should have_css 'ul.previously li a'
  end

  scenario 'should have a detail page for status message' do
    status_message = StatusMessage.first
    visit status_message_path(status_message)

    page.should have_content status_message.message

    page.should have_content 'Publicaciones anteriores de Aitana'
    page.should have_css 'ul.previously li a'
  end

end

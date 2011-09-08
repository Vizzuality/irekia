#encoding: UTF-8

require 'spec_helper'

feature "News page" do
  background do
    @news = News.first
  end

  scenario "shows news' title, subtitle and body" do
    visit news_path(@news)
    within '#news' do
      within '.date_area_and_comments' do
        page.should have_content '3 de agosto de 2011 · Educación, Universidades e Investigación · 2 comentarios'
        page.should have_link 'Educación, Universidades e Investigación'
        page.should have_link '2 comentarios'
      end
      within '.news_content' do
        page.should have_css 'h1', :text => 'Inauguración del nuevo complejo deportivo en la localidad de Getxo'
        page.should have_css 'h4', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
        page.should have_content String.lorem
      end
    end
  end

  scenario "has a sidebar with sharing links, a list of tags and related people and news" do
    visit news_path(@news)
    within '.sharing_links' do
      page.should have_link 'Mail'
      page.should have_link 'Twitter'
      page.should have_link 'Facebook'
    end
    within '.tags' do
      page.should have_css 'h3', :text => 'Tags'
      within 'ul' do
        page.should have_content 'Comisión'
        page.should have_content 'Transporte'
        page.should have_content 'Gobierno Vasco'
        page.should have_content 'Transporte'
      end
    end
    within '.related_politics' do
      page.should have_css 'h3', :text => 'Políticos relacionados'
      within 'ul' do
        page.should have_content 'Virginia Uriarte Rodríguez Consejera'
        page.should have_link 'Virginia Uriarte Rodríguez'
      end
    end
    within '.related_content' do
      page.should have_css 'h3', :text => 'Últimos contenidos'
      within 'ul' do
      end
    end
  end
end
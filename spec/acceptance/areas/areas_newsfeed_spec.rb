#encoding: UTF-8
require 'spec_helper'

feature "Areas newsfeed" do
  background do
    @area = init_area_data
  end

  scenario "Browsing areas' newsfeed" do
    visit area_path(@area)
peich
    within '#area_summary' do
      page.should have_css('h1', :text => 'Educación, Universidades e Investigación')
      page.should have_css('a.add_to_favorites')
      within '.description' do
        page.should have_css('h3', :text => 'Qué hacemos')
        page.should have_css('p',  :text => lorem)
      end
      within '.team' do
        page.should have_css('h3',         :text => 'Equipo principal')
        page.should have_css('ul li a',    :text => 'Virginia Uriarte Rodríguez')
        page.should have_css('ul li span', :text => 'Consejera')
        page.should have_css('ul li a',    :text => 'Alberto de Zárate López')
        page.should have_css('ul li span', :text => 'Vice-consejero')
      end
      within '.status' do
        page.should have_css('ul li.area span',      :text => '12 acciones esta semana')
        page.should have_css('ul li.area a',         :text => 'Sigue a este área')
        # page.should have_css('ul li.questions span', :text => '2 preguntas contestadas')
        # page.should have_css('ul li.questions a',    :text => 'Haz una pregunta')
        # page.should have_css('ul li.proposals span', :text => '3 propuestas abiertas')
        # page.should have_css('ul li.proposals a',    :text => 'Lanza tu propuesta')
      end
    end
  end
end
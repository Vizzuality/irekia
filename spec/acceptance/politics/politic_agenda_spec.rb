#encoding: UTF-8

require 'spec_helper'

feature "Area's agenda page" do

  background do
    @politic = init_politic_data
  end

  scenario "shows a summary with that politic's description, actions and questions answered" do

    visit agenda_politic_path(@politic)

    within '#politic_summary' do
      page.should have_css 'h1', :text => 'Virginia Uriarte Rodríguez'
      page.should have_css '.title', :text => 'Consejera de Educación, Universidades e Investigación'
      page.should have_link 'Educación, Universidades e Investigación'
      page.should have_css '.picture img'

      within '.description' do
        page.should have_css 'h3', :text => 'Quién es y qué hace'
        page.should have_css 'p',  :text => lorem
      end

      within '.actions' do
        page.should have_css 'span', :text => '6 acciones esta semana'
        page.should have_link 'Sigue a Virginia'
      end

      within '.questions' do
        page.should have_css 'span', :text => 'Una pregunta contestada'
        page.should have_link 'Pregunta a Virginia'
      end
    end
  end

  scenario 'shows a navigation menu with "actions" selected' do
    visit agenda_politic_path(@politic)

    within '.navigation' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas', :class => 'selected'
      page.should have_link 'Agenda'
    end
  end

  scenario "shows this politic's agenda in detail" do

    visit agenda_politic_path(@politic)

    within '#agenda' do
      page.should have_css 'h2', :text => 'Agenda de Virginia'

      page.should have_css 'a.view_calendar', :text => 'Ver calendario'
      page.should have_css 'a.view_map', :text => 'Ver mapa'

      within '.calendar' do
        (1..28).each do |n|
          page.should have_css '.date .day', :text => n.to_s
          page.should have_css '.date .month', :text => 'ago'
        end

        within 'li.ago_02' do
          page.should have_css 'div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 2
          within 'div.detail' do

            page.should have_css 'h4', :text => '02, agosto de 2011'
            page.should have_css 'h3', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
            page.should have_css '.location'#, :text => 'Unibertsitate Etorbidea, 24, University of Deusto, 48014 Bilbao, Spain'
            page.should have_css '.time', :text => '10:00'
          end
        end

        page.should have_css 'li.ago_04 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
        page.should have_css 'li.ago_11 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
      end

      page.should have_css '.pagination', :text => 'Ver calendario completo'
    end
  end

end
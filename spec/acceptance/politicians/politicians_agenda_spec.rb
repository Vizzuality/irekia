#encoding: UTF-8

require 'spec_helper'

feature "Area's agenda page" do

  background do
    @politician = get_politician_data
  end

  scenario "shows a summary with that politician's description, actions and questions answered" do

    visit agenda_politician_path(@politician)

    within '.summary' do
      page.should have_css 'h1', :text => 'Virginia Uriarte Rodríguez'
      page.should have_css '.position', :text => 'Consejera de Educación, Universidades e Investigación'
      page.should have_link 'Educación, Universidades e Investigación'
      page.should have_css 'img.xlAvatar'

      page.should have_css 'h3', :text => 'Quién es y qué hace'
      within '.description' do
        page.should have_css 'p',  :text => 'Virginia es Licenciada en Ciencias del Deporte y en Ciencias políticas por la Universidad Complutense de Madrid. En el Gobierno Vasco, Virgnia ha invertido grandes esfuerzos en la mejora de la Investigación, y en solo un año, ha conseguido que su papel se...'
      end

     # within '.actions' do
     #   page.should have_css 'span', :text => '7 acciones esta semana'
     #   page.should have_link 'Sigue a Virginia'
     # end

     # within '.questions' do
     #   page.should have_css 'span', :text => 'Una pregunta contestada'
     #   page.should have_link 'Pregunta a Virginia'
     # end
    end
  end

  scenario 'shows a navigation menu with "actions" selected' do
    visit agenda_politician_path(@politician)

    within 'ul.menu' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas', :class => 'selected'
      page.should have_link 'Agenda'
    end
  end

  scenario "shows this politician's agenda in detail" do

    visit agenda_politician_path(@politician)

    within '.agenda' do
      page.should have_css 'h2', :text => 'Agenda de Virginia'

      page.should have_css 'a.view_calendar', :text => 'Ver calendario'
      page.should have_css 'a.view_map', :text => 'Ver mapa'

      within '.content' do
        (1..28).each do |n|
          page.should have_css '.day h3', :text => n.to_s
          page.should have_css '.month', :text => 'ago'
        end

       # within 'li.ago_02' do
       #   page.should have_css 'div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 2
       #   within 'div.detail' do

       #     page.should have_css 'h4', :text => '02, agosto de 2011'
       #     page.should have_css 'h3', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
       #     page.should have_css '.location'#, :text => 'Unibertsitate Etorbidea, 24, University of Deusto, 48014 Bilbao, Spain'
       #     page.should have_css '.time', :text => '10:00'
       #   end
       # end

       # page.should have_css 'li.ago_04 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
       # page.should have_css 'li.ago_11 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
      end

      page.should_not have_css 'footer .right a', :text => 'Ver calendario completo'
    end
  end

end

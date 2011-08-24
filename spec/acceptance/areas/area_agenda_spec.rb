#encoding: UTF-8

require 'spec_helper'

feature "Area's agenda page" do

  background do
    @area = get_area_data
  end

  scenario "shows a summary of that area's politics, actions and generated contents" do

    visit agenda_area_path(@area)

    within '#area_summary' do
      page.should have_css 'h1', :text => 'Educación, Universidades e Investigación'
      page.should have_css 'a.add_to_favorites'

      within '.description' do
        page.should have_css 'h3', :text => 'Qué hacemos'
        page.should have_css 'p',  :text => lorem
      end

      within '.team' do
        page.should have_css 'h3',         :text => 'Equipo principal'
        page.should have_css 'ul li a',    :text => 'Virginia Uriarte Rodríguez'
        page.should have_css 'ul li span', :text => 'Consejera'
        page.should have_css 'ul li a',    :text => 'Alberto de Zárate López'
        page.should have_css 'ul li span', :text => 'Vice-consejero'
      end

      within '.status' do
        page.should have_css 'ul li.area span',      :text => '155 acciones esta semana'
        page.should have_css 'ul li.area a',         :text => 'Sigue a este área'
        page.should have_css 'ul li.questions span', :text => '1 pregunta contestada'
        page.should have_css 'ul li.questions a',    :text => 'Haz una pregunta'
        page.should have_css 'ul li.proposals span', :text => '1 propuesta abierta'
        page.should have_css 'ul li.proposals a',    :text => 'Lanza tu propuesta'
      end
    end
  end

  scenario 'shows a navigation menu with "agenda" selected' do
    visit agenda_area_path(@area)

    within '.navigation' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas'
      page.should have_link 'Agenda', :class => 'selected'
      page.should have_link 'Equipo'
    end
  end

  scenario "shows this area's agenda in detail" do

    visit agenda_area_path(@area)

    within '#agenda' do
      page.should have_css 'h2', :text => 'Agenda del área'

      page.should have_css 'a.view_calendar', :text => 'Ver calendario'
      page.should have_css 'a.view_map', :text => 'Ver mapa'

      within '.calendar' do
        (1..28).each do |n|
          page.should have_css '.date .day', :text => n.to_s
          page.should have_css '.date .month', :text => 'ago'
        end

        within 'li.ago_02' do
          page.should have_css 'div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 3
          within 'div.detail' do

            page.should have_css 'h4', :text => '02, agosto de 2011'
            page.should have_css 'h3', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
            page.should have_css '.location'#, :text => 'Unibertsitate Etorbidea, 24, University of Deusto, 48014 Bilbao, Spain'
            page.should have_css '.time', :text => '10:00'
          end
        end

        page.should have_css 'li.ago_03 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
        page.should have_css 'li.ago_04 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 3
        page.should have_css 'li.ago_10 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 3
        page.should have_css 'li.ago_11 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
        page.should have_css 'li.ago_12 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
      end
    end
  end
end
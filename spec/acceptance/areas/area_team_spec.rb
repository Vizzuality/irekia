#encoding: UTF-8

require 'spec_helper'

feature "Area's team page" do

  background do
    @area = init_area_data
  end

  scenario "shows a summary of that area's politics, actions and generated contents" do

    visit team_area_path(@area)

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
        page.should have_css 'ul li.area span',      :text => '30 acciones esta semana'
        page.should have_css 'ul li.area a',         :text => 'Sigue a este área'
        page.should have_css 'ul li.questions span', :text => '1 pregunta contestada'
        page.should have_css 'ul li.questions a',    :text => 'Haz una pregunta'
        page.should have_css 'ul li.proposals span', :text => '1 propuesta abierta'
        page.should have_css 'ul li.proposals a',    :text => 'Lanza tu propuesta'
      end
    end
  end

  scenario 'shows a navigation menu with "team" selected' do
    visit team_area_path(@area)

    within '.navigation' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas'
      page.should have_link 'Agenda'
      page.should have_link 'Equipo', :class => 'selected'
    end
  end

  scenario "shows that area's team" do

    visit team_area_path(@area)

    within '#team' do
      page.should have_css 'h1', :text => '5 personas implicadas en este área'

      page.should have_css 'ul li', :count => 5

      within 'ul li:first-child' do
        page.should have_css 'a img'
        page.should have_link 'Virginia Uriarte Rodríguez'
        page.should have_css '.title', :text => 'Consejera'
        page.should have_css '.actions_this_week', :text => '6 acciones esta semana'
      end
    end
  end
end
#encoding: UTF-8

require 'spec_helper'

feature "Area's team page" do

  background do
    @area = get_area_data
  end

  scenario "shows a summary of that area's politicians, actions and generated contents" do

    visit team_area_path(@area)

    within '.summary' do
      page.should have_css 'h1', :text => 'Educación, Universidades e Investigación'
      page.should have_css 'a.ribbon'
      page.should have_css 'h3', :text => 'Qué hacemos'
      page.should have_css 'p',  :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor'

      within 'ul.people' do
        page.should have_css 'li a',    :text => 'Virginia Uriarte Rodríguez'
        page.should have_css 'li span', :text => 'Consejera'
        page.should have_css 'li a',    :text => 'Alberto de Zárate López'
        page.should have_css 'li span', :text => 'Vice-consejero'
      end

    #  within '.status' do
    #    page.should have_css 'ul li.area span',      :text => '148 acciones esta semana'
    #    page.should have_css 'ul li.area a',         :text => 'Sigue a este área'
    #    page.should have_css 'ul li.questions span', :text => '1 pregunta contestada'
    #    page.should have_css 'ul li.questions a',    :text => 'Haz una pregunta'
    #    page.should have_css 'ul li.proposals span', :text => '1 propuesta abierta'
    #    page.should have_css 'ul li.proposals a',    :text => 'Lanza tu propuesta'
    #  end
    end
  end

  scenario 'shows a navigation menu with "team" selected' do
    visit team_area_path(@area)

    within '.menu' do
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

    within '.team' do
      page.should have_css 'h2', :text => '5 personas implicadas en este área'

      page.should have_css 'ul li', :count => 5

      within 'ul li:first-child' do
        page.should have_css 'a img'
        page.should have_link 'Virginia Uriarte Rodríguez'
        page.should have_css '.title', :text => 'Consejera'
      end
    end
  end
end

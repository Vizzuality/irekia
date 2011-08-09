#encoding: UTF-8

require 'spec_helper'

feature "Area's proposals page" do

  background do
    @area = init_area_data
  end

  scenario "shows a summary of that area's politics, actions and generated contents" do

    visit proposals_area_path(@area)

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

  scenario 'shows a navigation menu with "proposals" selected' do
    visit proposals_area_path(@area)

    within '.navigation' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas', :class => 'selected'
      page.should have_link 'Agenda'
      page.should have_link 'Equipo'
    end
  end

  scenario "shows the list of proposals sent to that area" do

    visit proposals_area_path(@area)

    within '#proposals' do
      page.should have_css 'h2', :text => 'Propuestas'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.action div.proposal' do
        page.should have_css 'p.title', :text => 'Actualizar la información publicada sobre las ayudas a familias numerosas'
        page.should have_css 'ul.arguments li', :text => '1 a favor'
        page.should have_css 'ul.arguments li', :text => '0 en contra'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css 'span.author a', :text => 'María González Pérez'
        page.should have_css 'a', :text => 'Un usuario ha participado'
      end

      within '.content_type_filters' do
        page.should have_link 'Todas'
        page.should have_link 'Propuestas del gobierno'
        page.should have_link 'Propuestas ciudadanas'
        page.should have_link 'Crea una propuesta'
      end

      page.should have_css '.pagination', :text => 'Ver más propuestas'
    end
  end
end
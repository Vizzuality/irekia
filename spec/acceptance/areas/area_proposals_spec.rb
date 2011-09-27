#encoding: UTF-8

require 'spec_helper'

feature "Area's proposals page" do

  background do
    @area = get_area_data
  end

  scenario "shows a summary of that area's politics, actions and generated contents" do

    visit proposals_area_path(@area)

    within '.summary' do
      page.should have_css 'h1', :text => 'Educación, Universidades e Investigación'
      page.should have_css 'a.add_to_favorites'
      page.should have_css 'h3', :text => 'Qué hacemos'
      page.should have_css 'p',  :text => String.lorem

      within 'ul.people' do
        page.should have_css 'li a',    :text => 'Virginia Uriarte Rodríguez'
        page.should have_css 'li span', :text => 'Consejera'
        page.should have_css 'li a',    :text => 'Alberto de Zárate López'
        page.should have_css 'li span', :text => 'Vice-consejero'
      end

     # within '.status' do
     #   page.should have_css 'ul li.area span',      :text => '148 acciones esta semana'
     #   page.should have_css 'ul li.area a',         :text => 'Sigue a este área'
     #   page.should have_css 'ul li.questions span', :text => '1 pregunta contestada'
     #   page.should have_css 'ul li.questions a',    :text => 'Haz una pregunta'
     #   page.should have_css 'ul li.proposals span', :text => '1 propuesta abierta'
     #   page.should have_css 'ul li.proposals a',    :text => 'Lanza tu propuesta'
     # end
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

    within '.proposals' do
      page.should have_css 'h2', :text => 'Propuestas'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      page.should have_css 'ul li.proposal div.avatar img'
      within 'ul li.proposal div.content' do
        page.should have_css 'p strong', :text => 'Actualizar la información publicada sobre las ayudas a familias numerosas'
        page.should have_css 'div.graphs span.legend', :text => '33 a favor'
        page.should have_css 'div.graphs span.legend', :text => '3 en contra'

        page.should have_css 'span.author', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css 'span.author a', :text => 'María González Pérez'
        page.should have_css 'a', :text => '123 usuarios han participado'
      end

#       within '.content_type_filters' do
#         page.should have_link 'Todas'
#         page.should have_link 'Propuestas del gobierno'
#         page.should have_link 'Propuestas ciudadanas'
#         page.should have_link 'Crea una propuesta'
#       end

      page.should have_css 'footer', :text => 'ver más propuestas'
    end

  end
end

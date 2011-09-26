#encoding: UTF-8

require 'spec_helper'

feature "Area's proposals page" do

  background do
    @politic = get_politic_data
  end

  scenario "shows a summary with that politic's description, actions and questions answered" do

    visit proposals_politic_path(@politic)

    within '.summary' do
      page.should have_css 'h1', :text => 'Virginia Uriarte Rodríguez'
      page.should have_css '.position', :text => 'Consejera de Educación, Universidades e Investigación'
      page.should have_link 'Educación, Universidades e Investigación'
      page.should have_css 'img.xlAvatar'

      within '.description' do
        page.should have_css 'h3', :text => 'Quién es y qué hace'
        page.should have_css 'p',  :text => String.lorem
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
    visit proposals_politic_path(@politic)

    within 'ul.menu' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas', :class => 'selected'
      page.should have_link 'Agenda'
    end
  end

  scenario "shows the list of proposals sent to that politic" do

    visit proposals_politic_path(@politic)

    within '.proposals' do
      page.should have_css 'h2', :text => 'Propuestas'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.proposal' do
        page.should have_css 'p', :text => 'Actualizar la información publicada sobre las ayudas a familias numerosas'

        within '.graphs' do
          page.should have_css '.sparkline.positive .legend' #, :text => '66 a favor'
          page.should have_css '.sparkline.negative .legend' #, :text => '57 en contra'
        end

        page.should have_css 'img'
        page.should have_css '.footer span.author', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css '.footer span.author a', :text => 'María González Pérez'
        page.should have_css '.footer a', :text => '123 usuarios han participado'
      end

      within '.selector' do
        page.should have_link 'Todas'
        page.should have_link 'Propuestas del gobierno'
        page.should have_link 'Propuestas ciudadanas'
      end
      page.should have_link 'Crea una propuesta'

      page.should have_css 'footer .inner .right a', :text => 'ver más propuestas'
    end
  end

end

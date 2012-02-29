#encoding: UTF-8
require 'spec_helper'

feature 'Area homepage' do
  scenario 'should have an area summary' do
    visit area_path(Area.presidencia)

    page.should have_css 'div#main.areas div.content div.article div.inner div.content header.clearfix h1 a.area_title', :text => 'Lehendakaritza'
    find('div#main.areas div.content div.article div.inner div.content div.left div.description div.first').text.should_not be_empty
    find('div#main.areas div.content div.article div.inner div.content div.left div.description div.last').text.should_not be_empty

    page.should have_button 'Seguir a este área'

    within '.people' do
      page.should have_css 'li',        :length => 3
      page.should have_css 'li a.name', :length => 2
    end

    within 'div#main.areas div.content ul.menu' do
      page.should have_link 'Resumen'
      page.should have_link 'Actividad'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas'
      page.should have_link 'Agenda'
      page.should have_link 'Equipo'
    end

    within 'div#actions-lehendakaritza.article' do
      page.should have_content 'Últimas acciones'
      page.should have_css 'div.inner div.left div.listing ul li.clearfix', :length => 6
    end

    within 'div#questions-lehendakaritza.article' do
      page.should have_content 'Preguntas de los ciudadanos'
      page.should have_content 'No hay preguntas en este área'
      page.should have_link 'Haz una pregunta'
    end

    within 'div#proposals-lehendakaritza.article' do
      page.should have_content 'Propuestas'
      page.should have_content 'No hay propuestas en este área'
      page.should have_link 'Crea una propuesta'
    end

    within 'div#events-lehendakaritza.article' do
      page.should have_content 'Agenda del área'
      page.should have_css 'div.inner div.content div.agenda_map ul.agenda li.day', :length => 14
    end
  end

  scenario 'should have an actions section' do

    visit area_path(Area.presidencia)

    click_link 'Actividad'

    within 'div#actions-lehendakaritza.article' do
      page.should have_content 'Últimas acciones'
      page.should have_css 'div.inner div.left div.listing ul li.clearfix', :length => 10

      within 'div.inner header.clearfix div.right ul.switch' do
        page.should have_link 'Más recientes'
        page.should have_link 'Más debatidas'
      end

      within 'div.inner div.right ul.selector' do
        page.should have_link    'Todos los tipos'
        page.should have_link    'Noticias'
        page.should have_content 'Preguntas'
        page.should have_link    'Propuestas'
        page.should have_link    'Fotos'
        page.should have_content 'Vídeos'
        page.should have_content 'Cambios de estado'
      end

      page.should have_link 'ver más acciones'

    end

  end

  scenario 'should have a questions section' do

    visit area_path(Area.presidencia)

    click_link 'Preguntas'

    within 'div#questions-lehendakaritza.article' do
      page.should have_content 'Preguntas de los ciudadanos'

      within 'div.inner header.clearfix div.right ul.switch' do
        page.should have_link 'Más recientes'
        page.should have_link 'Más debatidas'
      end

      within 'div.inner div.right ul.selector' do
        page.should have_link    'Todas'
        page.should have_link    'Contestadas'
      end

      page.should have_link 'Haz una pregunta'

    end
  end

  scenario 'should have a proposals section' do

    visit area_path(Area.presidencia)

    click_link 'Propuestas'

    within 'div#proposals-lehendakaritza.article' do
      page.should have_content 'Propuestas'

      within 'div.inner header.clearfix div.right ul.switch' do
        page.should have_link 'Más recientes'
        page.should have_link 'Más debatidas'
      end

      within 'div.inner div.right ul.selector' do
        page.should have_link    'Todas'
        page.should have_link    'Propuestas del gobierno'
        page.should have_link    'Propuestas ciudadanas'
      end

      page.should have_link 'Crea una propuesta'

    end
  end

  scenario 'should have an agenda section' do

    visit area_path(Area.presidencia)

    click_link 'Agenda'

    within 'div#events-lehendakaritza.article' do
      page.should have_content 'Agenda del área'
      page.should have_css 'div.inner div.content div.agenda_map ul.agenda li.day', :length => 28

      page.should have_link 'Mes anterior'
      page.should have_link 'Mes siguiente'
    end
  end

  scenario 'should have a team section' do

    visit area_path(Area.presidencia)

    click_link 'Equipo'

    within 'div#main.areas div.content div.article.team' do
      page.should have_content '20 personas implicadas en este área'
      page.should have_css 'div.inner div.content ul.suggestions li', :length => 20
    end

  end

end

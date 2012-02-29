#encoding: UTF-8
require 'spec_helper'

feature 'Politician homepage' do
  scenario "should have politician's summary" do
    visit politician_path(User.patxi_lopez)

    page.should have_css 'div#main.politicians div.content div.article div.inner header.clearfix h1', :text => 'Patxi López Álvarez'
    find('div#main.politicians div.content div.article div.inner div.left div.description div.first').text.should_not be_empty
    find('div#main.politicians div.content div.article div.inner div.left div.description div.last').text.should_not be_empty

    page.should have_button 'Seguir a Patxi'

    page.should have_link 'Leer más'

    within 'div#main div.content ul.menu' do
      page.should have_link 'Resumen'
      page.should have_link 'Actividad'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas'
      page.should have_link 'Agenda'
    end

    within 'div#actions-patxi-lopez-alvarez.article' do
      page.should have_content 'Últimas acciones'
      page.should have_content 'No hay contenido para Patxi'
    end

    within 'div#questions-patxi-lopez-alvarez.article' do
      page.should have_content 'Preguntas de los ciudadanos'
      page.should have_content 'No hay preguntas para Patxi'
      page.should have_link 'Haz una pregunta'
    end

    within 'div#proposals-patxi-lopez-alvarez.article' do
      page.should have_content 'Propuestas'
      page.should have_content 'No hay propuestas para Patxi'
      page.should have_link 'Crea una propuesta'
    end

    within 'div#events-patxi-lopez-alvarez.article' do
      page.should have_content 'Agenda de Patxi'
      page.should have_css 'div.inner div.content div.agenda_map ul.agenda li.day', :length => 14
    end
  end

  scenario 'should have an actions section' do

    visit politician_path(User.patxi_lopez)

    click_link 'Actividad'

    within 'div#actions-patxi-lopez-alvarez.article' do
      page.should have_content 'Últimas acciones'

      within 'div.inner header.clearfix div.right ul.switch' do
        page.should have_link 'Más recientes'
        page.should have_link 'Más debatidas'
      end

      within 'div.inner div.right ul.selector' do
        page.should have_content 'Todos los tipos'
        page.should have_content 'Noticias'
        page.should have_content 'Preguntas'
        page.should have_content 'Propuestas'
        page.should have_content 'Fotos'
        page.should have_content 'Vídeos'
        page.should have_content 'Cambios de estado'
      end

    end

  end

  scenario 'should have a questions section' do

    visit politician_path(User.patxi_lopez)

    click_link 'Preguntas'

    within 'div#questions-patxi-lopez-alvarez.article' do
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

    visit politician_path(User.patxi_lopez)

    click_link 'Propuestas'

    within 'div#proposals-patxi-lopez-alvarez.article' do
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

    visit politician_path(User.patxi_lopez)

    click_link 'Agenda'

    within 'div#events-patxi-lopez-alvarez.article' do
      page.should have_content 'Agenda de Patxi'
      page.should have_css 'div.inner div.content div.agenda_map ul.agenda li.day', :length => 28

      page.should have_link 'Mes anterior'
      page.should have_link 'Mes siguiente'
    end
  end
end


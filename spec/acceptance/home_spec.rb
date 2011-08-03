#encoding: UTF-8

require 'spec_helper'

feature "Home" do
  scenario "has a layout common to all pages" do
    visit root_path

    within '#header' do
      page.should have_css 'img', :src => '/images/irekia_logo.jpg'
      page.should have_css 'img', :src => '/images/euskadi_net_logo.jpg'
      within 'ul' do
        page.should have_link 'Contacto'
        page.should have_link 'Ayuda'
        page.should have_link 'Mapa'
        page.should have_link 'Accesibilidad'
        page.should have_link 'Mis gestiones'
      end
    end

    within '#navigation' do
      page.should have_content 'Estás viendo...'
      page.should have_css 'ul.areas'
      page.should have_no_css 'ul.areas li'
      page.should have_no_css 'ul.areas li.selected'

      within 'form' do
        page.should have_css 'label', :text => 'O busca lo que necesitas...'
        page.should have_css 'input', :type => 'text'
        page.should have_css 'input', :type => 'submit'
      end

      within '.auth' do
        page.should have_link 'Regístrate'
        page.should have_link 'Login'

        page.should have_css 'h1', :text => 'Accede a Irekia'
        page.should have_css 'p', :text => '¿Olvidaste tu contraseña? Recupérala aquí'
        page.should have_link 'Recupérala aquí'
        within 'form' do
          page.should have_css 'label', :text => 'Email'
          page.should have_css 'input', :type => 'text'
          page.should have_css 'label', :text => 'Contraseña'
          page.should have_css 'input', :type => 'text'
          page.should have_css 'input', :type => 'checkbox'
          page.should have_css 'label', :text => 'Recordar mis datos'
          page.should have_css 'input', :type => 'submit', :value => 'Entrar'
        end
      end
    end

    page.should have_css '#content'

    within '#footer' do
      within '.copyright' do
        page.should have_css 'img', :src => '/images/logo.jpg'
        page.should have_link 'Información legal'
        page.should have_content '© 2011 Eusko Jaurlaritza'
        page.should have_content 'Gobierno Vasco'
      end

      within '.home' do
        page.should have_css 'h4', :text => 'Inicio'
        within 'ul' do
          page.should have_link 'Agenda'
          page.should have_link 'Propuestas'
          page.should have_link 'Regístrate'
          page.should have_link 'Accede a tu cuenta'
        end
      end

      within '.areas' do
        page.should have_css 'h4', :text => 'Áreas'
        within 'ul' do
          page.should have_link 'Gobierno Vasco'
          page.should have_link 'Presidencia'
          page.should have_link 'Interior'
          page.should have_link 'Educación e Investigación'
          page.should have_link 'Economía y Hacienda'
          page.should have_link 'Justicia y Admon. Pública'
          page.should have_link 'Vivienda'
          page.should have_link 'Obras Públicas y Transportes'
          page.should have_link 'Industria e Innovación'
          page.should have_link 'Comercio y Turismo'
          page.should have_link 'Empleo y Asuntos Sociales'
          page.should have_link 'Sanidad y Consumo'
          page.should have_link 'Medio Ambiente'
          page.should have_link 'Cultura y Deporte'
        end
      end

      within '.about' do
        page.should have_css 'h4', :text => '¿Qué es Irekia?'
        within 'ul' do
          page.should have_link 'Ayuda'
          page.should have_link 'FAQ'
        end
      end
    end

  end
end
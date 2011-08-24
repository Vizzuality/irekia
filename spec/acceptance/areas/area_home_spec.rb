#encoding: UTF-8

require 'spec_helper'

feature "Area's home" do

  background do
    @area = get_area_data
  end

  scenario "shows a summary of that area's politics, actions and generated contents" do

    visit area_path(@area)

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
        page.should have_css 'ul li.area span',      :text => '159 acciones esta semana'
        page.should have_css 'ul li.area a',         :text => 'Sigue a este área'
        page.should have_css 'ul li.questions span', :text => '1 pregunta contestada'
        page.should have_css 'ul li.questions a',    :text => 'Haz una pregunta'
        page.should have_css 'ul li.proposals span', :text => '1 propuesta abierta'
        page.should have_css 'ul li.proposals a',    :text => 'Lanza tu propuesta'
      end
    end
  end

  scenario 'shows a list of last actions related to that area' do

    visit area_path(@area)

    within '#last_actions' do
      page.should have_css 'h2', :text => 'Últimas acciones'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.action div.argument' do
        page.should have_css 'p.title', :text => 'A favor de la propuesta "Actualizar la información publicada sobre las ayudas a familias numerosas"'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => /Aritz Aranburu participó hace (menos de )?\d+ minuto(s)?/
        page.should have_css 'span.author a', :text => 'Aritz Aranburu'
        page.should have_css 'a', :text => 'Ningún comentario'
        page.should have_css 'a', :text => 'Compartir'
      end

      within 'ul li.action div.answer' do
        page.should have_css 'p.title', :text => 'Contestando a "Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'
        page.should have_css 'p.answer', :text => '"Hola María, en realidad no va a haber ayuda este año. El recorte este"'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => /Virginia Uriarte Rodríguez contesto hace (menos de )?\d+ minuto(s)?/
        page.should have_css 'span.author a', :text => 'Virginia Uriarte Rodríguez'
        page.should have_css 'a', :text => '1 comentario'
        page.should have_css 'a', :text => 'Compartir'
      end

      within 'ul li.action div.news' do
        page.should have_css 'p.title', :text => 'Inauguración del nuevo complejo deportivo en la localidad de Getxo'
        page.should have_css 'p.news', :text => %{"#{lorem}"}

        page.should have_no_css 'img'
        page.should have_css 'span.author', :text => /Publicado hace (menos de )?\d+ minuto(s)?/
        page.should have_css 'a', :text => '2 comentarios'
        page.should have_css 'a', :text => 'Compartir'
      end

      within 'ul li.action div.question' do
        page.should have_css 'p.title', :text => 'Pregunta para el área...'
        page.should have_css 'p.question', :text => '"Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => /María González Pérez hace (menos de )?\d+ minuto(s)?/
        page.should have_css 'span.author a', :text => 'María González Pérez'
        page.should have_css 'a', :text => 'Ningún comentario'
        page.should have_css 'a', :text => 'Compartir'
      end

      within '.content_type_filters' do
        page.should have_link 'Todos los tipos'
        page.should have_link 'Noticias'
        page.should have_link 'Actividad de los políticos'
        page.should have_link 'Preguntas'
        page.should have_link 'Propuestas'
        page.should have_link 'Fotos'
        page.should have_link 'Vídeos'
      end

      page.should have_css '.pagination', :text => 'Ver más acciones'
    end
  end

  scenario "shows the list of questions made to that area" do

    visit area_path(@area)

    within '#questions' do
      page.should have_css 'h2', :text => 'Preguntas de los ciudadanos'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.action:first-child div.question' do
        page.should have_css 'p.title', :text => 'Pregunta para Virginia Uriarte Rodríguez...'
        page.should have_css 'p.question', :text => '"¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?"'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => /María González Pérez hace (menos de )?\d+ minuto(s)?/
        page.should have_css 'span.author a', :text => 'María González Pérez'
        page.should have_css 'a', :text => 'Aún no contestada'
        page.should have_css 'a', :text => '1 comentario'
      end

      within 'ul li.action:last-child div.question' do
        page.should have_css 'p.title', :text => 'Pregunta para el área...'
        page.should have_css 'p.question', :text => '"Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => /María González Pérez hace (menos de )?\d+ minuto(s)?/
        page.should have_css 'span.author a', :text => 'María González Pérez'
        page.should have_css 'a', :text => /Contestada hace (menos de )?\d+ minuto(s)?/
        page.should have_css 'a', :text => 'Ningún comentario'
      end

      within '.content_type_filters' do
        page.should have_link 'Todas'
        page.should have_link 'Contestadas'
        page.should have_link 'Haz una pregunta'
      end

      page.should have_css '.pagination', :text => 'Ver más preguntas'
    end
  end

  scenario "shows the list of proposals sent to that area" do

    visit area_path(@area)

    within '#proposals' do
      page.should have_css 'h2', :text => 'Propuestas'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.action div.proposal' do
        page.should have_css 'p.title', :text => 'Actualizar la información publicada sobre las ayudas a familias numerosas'
        page.should have_css 'ul.arguments li', :text => '66 a favor'
        page.should have_css 'ul.arguments li', :text => '57 en contra'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => /María González Pérez hace (menos de )?\d+ minuto(s)?/
        page.should have_css 'span.author a', :text => 'María González Pérez'
        page.should have_css 'a', :text => '123 usuarios han participado'
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

  scenario "shows that area's agenda" do

    visit area_path(@area)

    within '#agenda' do
      page.should have_css 'h2', :text => 'Agenda del área'

      page.should have_css 'a.view_calendar', :text => 'Ver calendario'
      page.should have_css 'a.view_map', :text => 'Ver mapa'

      within '.calendar' do
        (1..14).each do |n|
          page.should have_css '.date .day', :text => n.to_s
          page.should have_css '.date .month', :text => 'ago'
          page.should have_no_css '.detail'
        end

        page.should have_css 'li.ago_02 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 3
        page.should have_css 'li.ago_03 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
        page.should have_css 'li.ago_04 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 3
        page.should have_css 'li.ago_10 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 3
        page.should have_css 'li.ago_11 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
        page.should have_css 'li.ago_12 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
      end

      page.should have_css '.pagination', :text => 'Ver calendario completo'
    end
  end

end
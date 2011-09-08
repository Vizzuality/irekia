#encoding: UTF-8

require 'spec_helper'

feature "Search" do

  scenario "shows a summary of search results in its main tab" do
    visit search_path(:search => {:q => 'lorem'})

    within '#search' do

      within '.search_box' do
        page.should have_css 'h1', 'Resultados de tu búsqueda'
        page.should have_field 'search_q', :with => 'lorem'
      end

      within 'ul.tabs' do
        page.should have_css 'li.selected', :text => 'Resumen'
        page.should have_css 'li', :text => '137 contenidos'
        page.should have_css 'li', :text => '5 políticos'
        page.should have_css 'li', :text => '3 usuarios'
      end

      within '.contents_results' do
        page.should have_css 'h2', :text => '137 contenidos'

        page.should have_css 'ul li div', :count => 5
        within 'ul li' do
          page.should have_content 'Inauguración del nuevo complejo deportivo en la localidad de Getxo'
          page.should have_content 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed d...'
          page.should have_link 'Leer más'
          page.should have_content 'Publicado hace menos de 1 minuto · 2 comentarios · Compartir'
          page.should have_link '2 comentarios'
          page.should have_link 'Compartir'
        end
        page.should have_link 'ver los 137 contenidos encontrados'

        within '.main_filters' do
          page.should have_css 'a.more_recent.selected', :text => 'Más recientes'
          page.should have_css 'a.more_polemic', :text => 'Más polémicas'
        end

        within '.content_type_filters' do
          page.should have_css 'a.selected', :text => 'Todos los tipos'
          page.should have_link 'Noticias'
          page.should have_link 'Actividad de los políticos'
          page.should have_link 'Preguntas'
          page.should have_link 'Propuestas'
          page.should have_link 'Fotos'
          page.should have_link 'Vídeos'
        end
      end

      within '.politics_results' do
        page.should have_css 'h2', :text => '5 políticos'
        page.should have_css 'ul li', :count => 5
        within 'ul li' do
          page.should have_css 'img'
          page.should have_link 'Alberto de Zárate López'
          page.should have_content 'Vice-consejero de Educación, Universidades e Investigación'
          page.should have_link 'Seguir'
        end
        page.should_not have_link 'ver los 5 políticos encontrados'
      end

      within '.users_results' do
        page.should have_css 'h2', :text => '3 usuarios'
        page.should have_css 'ul li', :count => 3
        within 'ul li' do
          page.should have_css 'img'
          page.should have_link 'María González Pérez'
          page.should have_content 'Ondarroa, Vizcaya'
          page.should have_link 'Seguir'
        end
        page.should_not have_link 'ver los 3 usuarios encontrados'
      end
    end

  end

  scenario "shows a detail page for content type results" do
    visit search_path(:search => {:q => 'lorem'})

    within '#search' do

      within '.search_box' do
        page.should have_field 'search_q', :with => 'lorem'
      end

      click_link '137 contenidos'
    end

    within '#search' do

      within '.search_box' do
        page.should have_css 'h1', 'Resultados de tu búsqueda'
        page.should have_field 'search_q', :with => 'lorem'
      end

      within 'ul.tabs' do
        page.should have_css 'li', :text => 'Resumen'
        page.should have_css 'li.selected', :text => '137 contenidos'
        page.should have_css 'li', :text => '5 políticos'
        page.should have_css 'li', :text => '3 usuarios'
      end

      within '.contents_results' do
        page.should have_css 'h2', :text => '137 contenidos'

        page.should have_css 'ul li div', :count => 10
        within 'ul li' do
          page.should have_content 'Inauguración del nuevo complejo deportivo en la localidad de Getxo'
          page.should have_content 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed d...'
          page.should have_link 'Leer más'
          page.should have_content 'Publicado hace menos de 1 minuto · 2 comentarios · Compartir'
          page.should have_link '2 comentarios'
          page.should have_link 'Compartir'
        end
        page.should have_link 'ver más resultados'

        within '.main_filters' do
          page.should have_css 'a.more_recent.selected', :text => 'Más recientes'
          page.should have_css 'a.more_polemic', :text => 'Más polémicas'
        end

        within '.content_type_filters' do
          page.should have_css 'a.selected', :text => 'Todos los tipos'
          page.should have_link 'Noticias'
          page.should have_link 'Actividad de los políticos'
          page.should have_link 'Preguntas'
          page.should have_link 'Propuestas'
          page.should have_link 'Fotos'
          page.should have_link 'Vídeos'
        end
      end

    end

  end

  scenario "shows a detail page for politics type results" do
    visit search_path(:search => {:q => 'lorem'})

    within '#search' do

      within '.search_box' do
        page.should have_field 'search_q', :with => 'lorem'
      end

      click_link '5 políticos'
    end

    within '#search' do

      within '.search_box' do
        page.should have_css 'h1', 'Resultados de tu búsqueda'
        page.should have_field 'search_q', :with => 'lorem'
      end

      within 'ul.tabs' do
        page.should have_css 'li', :text => 'Resumen'
        page.should have_css 'li', :text => '137 contenidos'
        page.should have_css 'li.selected', :text => '5 políticos'
        page.should have_css 'li', :text => '3 usuarios'
      end

      within '.politics_results' do
        page.should have_css 'h2', :text => '5 políticos'
        within 'ul' do
          page.should have_css 'li', :count => 5
          within 'li' do
            page.should have_css 'img'
            page.should have_link 'Alberto de Zárate López'
            page.should have_content 'Vice-consejero de Educación, Universidades e Investigación'
            page.should have_link 'Seguir'
          end
        end
        page.should_not have_link 'ver más resultados'

        within '.main_filters' do
          page.should have_css 'a.more_recent.selected', :text => 'Más recientes'
          page.should have_css 'a.more_active', :text => 'Más activos'
        end

        within '.area_filters' do
          page.should have_css 'a.selected', :text => 'Todas las áreas'
          page.should have_link 'Educación, Universidades e Investigación'
        end
      end

    end

  end

  scenario "shows a detail page for users type results" do
    visit search_path(:search => {:q => 'lorem'})

    within '#search' do

      within '.search_box' do
        page.should have_field 'search_q', :with => 'lorem'
      end

      click_link '3 usuarios'
    end

    within '#search' do

      within '.search_box' do
        page.should have_css 'h1', 'Resultados de tu búsqueda'
        page.should have_field 'search_q', :with => 'lorem'
      end

      within 'ul.tabs' do
        page.should have_css 'li', :text => 'Resumen'
        page.should have_css 'li', :text => '137 contenidos'
        page.should have_css 'li', :text => '5 políticos'
        page.should have_css 'li.selected', :text => '3 usuarios'
      end

      within '.users_results' do
        page.should have_css 'h2', :text => '3 usuarios'

        within 'ul li' do
          page.should have_css 'img'
          page.should have_link 'María González Pérez'
          page.should have_content 'Ondarroa, Vizcaya'
          page.should have_link 'Seguir'
        end
        page.should_not have_link 'ver más resultados'

        within '.main_filters' do
          page.should have_css 'a.more_recent.selected', :text => 'Más recientes'
          page.should have_css 'a.more_active', :text => 'Más activos'
        end

        within '.location_filters' do
          page.should have_content 'Buscar un municipio'
          page.should have_field 'city', :with => 'Buscar un municipio'
        end
      end

    end

  end

  scenario "shows an autocomplete dialog using the main search box in application layout", :js => true do
    visit root_path

    within '#navigation form' do
      fill_in 'O busca lo que necesitas...', :with => 'lorem'
      click_button 'search_submit'
    end

    within '.autocomplete' do
      within '.politics' do
        within '.summary' do
          page.should have_content 'Políticos 5 encontrados'
          page.should have_link '5 encontrados'
        end
        page.should have_css 'ul li', :count => 2
        within 'ul li' do
          page.should have_css 'img'
          page.should have_link 'Alberto de Zárate López'
          page.should have_content 'Vice-consejero de Educación, Universidades e Investigación'
        end
      end

      within '.areas' do
        within '.summary' do
          page.should have_content 'Áreas'
        end
        page.should have_css 'ul li', :count => 1
        within 'ul li' do
          page.should have_link 'Educación, Universidades e Investigación'
        end
      end


      within '.users' do
        within '.summary' do
          page.should have_content 'Usuarios 3 encontrados'
          page.should have_link '3 encontrados'
        end
        page.should have_css 'ul li', :count => 2
        within 'ul li' do
          page.should have_css 'img'
          page.should have_link 'María González Pérez'
          page.should have_content 'Ondarroa, Vizcaya'
        end
      end

      within '.contents' do
        within '.summary' do
          page.should have_content 'Contenidos'
        end
        page.should have_link '137 contenidos encontrados'
      end

    end


  end

end
#encoding: UTF-8

require 'spec_helper'

feature "Search" do

  scenario "shows a summary of search results in its main tab" do
    visit search_path(:search => {:query => 'lorem'})

    page.should have_css 'h2', :text => 'Resultados de tu búsqueda'
    page.should have_field 'search_query', :with => 'lorem'

    within 'ul.menu' do
      page.should have_css 'li.selected', :text => 'Resumen'

      page.should have_css 'li', :text => '139 contenidos'
      page.should have_css 'li', :text => '4 políticos'
      page.should have_css 'li', :text => '3 usuarios'
    end

    within '.contents_results' do
      page.should have_css 'h2', :text => '139 contenidos'

      #page.should have_css '.left ul li', :count => 4

      within '.left ul li' do
        page.should have_content 'Actualizar la información publicada sobre las ayudas a familias numerosas'
        page.should have_content 'María González Pérez hace menos de 1 minuto · 1 comentario · Compartir'
        page.should have_link 'María González Pérez'
        page.should have_link '1 comentario'
        page.should have_link 'Compartir'
      end
      page.should have_link 'ver los 139 contenidos encontrados'

      within '.switch' do
        page.should have_css 'a.filter.selected', :text => 'Más recientes'
        page.should have_css 'a.filter', :text => 'Más polémicas'
      end

      within '.selector' do
        page.should have_css 'a.selected', :text => 'Todos los tipos'
        page.should have_link 'Noticias'
        page.should have_link 'Preguntas'
        page.should have_link 'Propuestas'
        page.should have_link 'Fotos'
        page.should have_link 'Vídeos'
      end
    end

    within '.politicians_results' do
      page.should have_css 'h2', :text => '4 políticos'
      page.should have_css 'div.content .suggestions li', :count => 4
      within 'div.content .suggestions li' do
        page.should have_css 'img'
        page.should have_link 'Alberto de Zárate López'
        page.should have_content 'Vice-consejero de Educación, Universidades e Investigación'
        page.should have_link 'Seguir'
      end
      page.should_not have_link 'ver los 4 políticos encontrados'
    end

    within '.users_results' do
      page.should have_css 'h2', :text => '3 usuarios'
      page.should have_css 'div.content ul.suggestions li', :count => 3
      within 'div.content .suggestions li' do
        page.should have_css 'img'
        page.should have_link 'Andrés Berzoso Rodríguez'
        page.should have_content 'Ondarroa, Vizcaya'
        page.should have_link 'Seguir'
      end
      page.should_not have_link 'ver los 3 usuarios encontrados'
    end
  end

  scenario "shows a detail page for content type results" do
    visit search_path(:search => {:query => 'lorem'})

    page.should have_field 'search_query', :with => 'lorem'

    within 'ul.menu' do
      click_link '139 contenidos'
    end


    page.should have_css 'h2', 'Resultados de tu búsqueda'
    page.should have_field 'search_query', :with => 'lorem'

    within 'ul.menu' do
      page.should have_css 'li', :text => 'Resumen'
      page.should have_css 'li.selected', :text => '139 contenidos'
      page.should have_css 'li', :text => '4 políticos'
      page.should have_css 'li', :text => '3 usuarios'
    end

    within '.contents_results' do
      page.should have_css 'h2', :text => '139 contenidos'

      #page.should have_css '.left ul li', :count => 10

      within '.left ul li' do
        page.should have_content 'Actualizar la información publicada sobre las ayudas a familias numerosas'
        page.should have_content 'María González Pérez hace menos de 1 minuto · 1 comentario · Compartir'
        page.should have_link 'María González Pérez'
        page.should have_link '1 comentario'
        page.should have_link 'Compartir'
      end
      page.should have_link 'ver más resultados'

      within '.switch' do
        page.should have_css 'a.filter.selected', :text => 'Más recientes'
        page.should have_css 'a.filter', :text => 'Más polémicas'
      end

      within '.selector' do
        page.should have_css 'a.selected', :text => 'Todos los tipos'
        page.should have_link 'Noticias'
        page.should have_link 'Preguntas'
        page.should have_link 'Propuestas'
        page.should have_link 'Fotos'
        page.should have_link 'Vídeos'
      end
    end
  end

  scenario "shows a detail page for politicians type results" do
    visit search_path(:search => {:query => 'lorem'})

    page.should have_field 'search_query', :with => 'lorem'

    within 'ul.menu' do
      click_link '4 políticos'
    end


    page.should have_css 'h2', 'Resultados de tu búsqueda'
    page.should have_field 'search_query', :with => 'lorem'

    within 'ul.menu' do
      page.should have_css 'li', :text => 'Resumen'
      page.should have_css 'li', :text => '139 contenidos'
      page.should have_css 'li.selected', :text => '4 políticos'
      page.should have_css 'li', :text => '3 usuarios'
    end

    within '.politicians_results' do
      page.should have_css 'h2', :text => '4 políticos'
      within 'div.content' do
        page.should have_css '.suggestions li', :count => 4
        within '.suggestions li' do
          page.should have_css 'img'
          page.should have_link 'Alberto de Zárate López'
          page.should have_content 'Vice-consejero de Educación, Universidades e Investigación'
          page.should have_link 'Seguir'
        end
      end
      page.should_not have_link 'ver más resultados'

      #within '.switch' do
      #  page.should have_css 'a.filter.selected', :text => 'Más recientes'
      #  page.should have_css 'a.filter', :text => 'Más activos'
      #end

      #within '.area_filters' do
      #  page.should have_css 'a.selected', :text => 'Todas las áreas'
      #  page.should have_link 'Educación, Universidades e Investigación'
      #end
    end
  end

  scenario "shows a detail page for users type results" do
    visit search_path(:search => {:query => 'lorem'})


    page.should have_field 'search_query', :with => 'lorem'

    within 'ul.menu' do
      click_link '3 usuarios'
    end


    page.should have_css 'h2', 'Resultados de tu búsqueda'
    page.should have_field 'search_query', :with => 'lorem'

    within 'ul.menu' do
      page.should have_css 'li', :text => 'Resumen'
      page.should have_css 'li', :text => '139 contenidos'
      page.should have_css 'li', :text => '4 políticos'
      page.should have_css 'li.selected', :text => '3 usuarios'
    end

    within '.users_results' do
      page.should have_css 'h2', :text => '3 usuarios'

      within 'div.content .suggestions li' do
        page.should have_css 'img'
        page.should have_link 'Andrés Berzoso Rodríguez'
        page.should have_content 'Ondarroa, Vizcaya'
        page.should have_link 'Seguir'
      end
      page.should_not have_link 'ver más resultados'

     # within '.switch' do
     #   page.should have_css 'a.filter.selected', :text => 'Más recientes'
     #   page.should have_css 'a.filter', :text => 'Más activos'
     # end

     # within '.location_filters' do
     #   page.should have_content 'Buscar un municipio'
     #   page.should have_field 'city', :with => 'Buscar un municipio'
     # end
    end
  end

  scenario "shows an autocomplete dialog using the main search box in application layout", :js => true do
    visit root_path

    within 'nav form' do
      fill_in 'search_query', :with => 'lorem'
      click_button 'search_submit'
    end

    within '.autocomplete' do
      within '.politicians' do
        within '.summary' do
          page.should have_css 'h3', :text => 'POLÍTICOS'
          page.should have_link '4 encontrados'
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
          page.should have_css 'h3', :text => 'USUARIOS'
          page.should have_link '3 encontrados'
        end
        page.should have_css 'ul li', :count => 2
        within 'ul li' do
          page.should have_css 'img'
          page.should have_link 'Andrés Berzoso Rodríguez'
          page.should have_content 'Ondarroa, Vizcaya'
        end
      end

      within '.contents' do
        within '.summary' do
          page.should have_content 'Contenidos'
        end
        page.should have_link '139 contenidos encontrados'
      end

    end
  end
end

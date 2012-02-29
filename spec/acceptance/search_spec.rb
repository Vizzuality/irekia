#encoding: UTF-8
require 'spec_helper'

feature 'Search' do
  scenario 'should allow search for contents in the whole application' do
    visit search_path

    within 'div.search_box' do
      fill_in 'search_query', :with => 'educ'
      click_on 'search_submit'
    end

    within 'div.article.results' do
      page.should have_content '10 contenidos'
      page.should have_css 'div.inner div.left div.listing ul li.clearfix', :length => 10

      page.should have_link 'Más recientes'
      page.should have_link 'Más debatidas'

      page.should have_link    'Todos los tipos'
      page.should have_link    'Noticias'
      page.should have_content 'Preguntas'
      page.should have_content 'Propuestas'
      page.should have_content 'Fotos'
      page.should have_content 'Vídeos'

      page.should have_link 'ver los 10 contenidos encontrados'
    end

    click_on '10 contenidos'


    within 'div.article.results' do
      page.should have_content '10 contenidos'
      page.should have_css 'div.inner div.left div.listing ul li.clearfix', :length => 10

      page.should have_link 'Más recientes'
      page.should have_link 'Más debatidas'

      page.should have_link    'Todos los tipos'
      page.should have_link    'Noticias'
      page.should have_content 'Preguntas'
      page.should have_content 'Propuestas'
      page.should have_content 'Fotos'
      page.should have_content 'Vídeos'

      page.should have_link 'ver más resultados'
    end

  end

  scenario 'should allow search for politicians in the whole application' do

    visit search_path

    within 'div.search_box' do
      fill_in 'search_query', :with => 'educ'
      click_on 'search_submit'
    end

    within 'div#politicians' do
      page.should have_content '1 político'
      page.should have_css 'ul.suggestions li', :length => 1
      page.should have_link 'Javier Jimenez Alvarez'
      page.should have_button 'Seguir'
    end

    click_on '1 político'

    within 'div#politicians' do
      page.should have_content '1 político'
      page.should have_css 'ul.suggestions li', :length => 1
      page.should have_link 'Javier Jimenez Alvarez'
      page.should have_button 'Seguir'
    end
  end

  scenario 'should allow search for areas in the whole application' do

    visit search_path

    within 'div.search_box' do
      fill_in 'search_query', :with => 'educ'
      click_on 'search_submit'
    end

    within 'div#areas.article' do
      page.should have_content '1 área'
      page.should have_css 'ul.suggestions li', :length => 1
      page.should have_link 'Educación, Universidades e Investigación'
      page.should have_button 'Seguir'
    end

    click_on '1 área'

    within 'div#areas' do
      page.should have_content '1 área'
      page.should have_css 'ul.suggestions li', :length => 1
      page.should have_link 'Educación, Universidades e Investigación'
      page.should have_button 'Seguir'
    end
  end

end

#encoding: UTF-8

require 'spec_helper'

feature "Photo page" do
  background do
    validate_all_not_moderated
    @photo = Photo.first
  end

  scenario "shows a photo with its title" do
    visit photo_path(@photo)

    within '#photo' do
      within '.title' do
        page.should have_css 'h1', :text => 'Presentación del Gobierno Vasco 2010'
        page.should have_content '3 de agosto de 2011 · Presentación del Gobierno Vasco 2010 · 2 comentarios'
        page.should have_link 'Presentación del Gobierno Vasco 2010'
        page.should have_link '2 comentarios'
      end
      within '.content' do
        page.should have_css 'img'
        page.should have_content 'Presentación del Nuevo Gobierno Vasco, formado tras las elecciones de 2010'
      end
    end
  end

  scenario "has a sidebar with sharing links and the list of last tweets of that user" do
    visit photo_path(@photo)

    within '.sharing_links' do
      page.should have_link 'Mail'
      page.should have_link 'Twitter'
      page.should have_link 'Facebook'
    end
    within '.tags' do
      page.should have_css 'h3', :text => 'Tags'
      within 'ul' do
        page.should have_content 'Comisión'
        page.should have_content 'Transporte'
        page.should have_content 'Gobierno Vasco'
        page.should have_content 'Transporte'
      end
    end
    within '.related_politics' do
      page.should have_css 'h3', :text => 'Políticos relacionados'
      within 'ul' do
        page.should have_content 'Virginia Uriarte Rodríguez Consejera'
        page.should have_link 'Virginia Uriarte Rodríguez'
      end
    end
    within '.related_photos' do
      page.should have_css 'h3', :text => 'Últimas fotos'
      within 'ul' do
      end
    end
  end

end
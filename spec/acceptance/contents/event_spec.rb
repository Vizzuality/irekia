#encoding: UTF-8

require 'spec_helper'

feature "Event page" do
  background do
    validate_all_not_moderated
    @event = Event.last
  end

  scenario "shows event's title, subtitle and content" do
    visit event_path(@event)

    within '#event' do
      within '.title' do
        page.should have_content '12 de agosto de 2011 a partir de las 12'
      end
      within '.content' do
        page.should have_css 'h1', :text => 'Reunión con el Sindicato de Estudiantes Universitarios'
        page.should have_css 'h4', :text => 'Un jurado internacional ha decidido que San Sebastián - Donostia sea designada como Capital Europea de la Cultura 2016'
        page.should have_content String.lorem
      end
    end
  end

  scenario "has a sidebar with sharing links and the list of last tweets of that user" do
    visit event_path(@event)

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
        page.should have_content 'Alberto de Zárate López Vice-consejero'
        page.should have_link 'Alberto de Zárate López'
      end
    end
    within '.related_events' do
      page.should have_css 'h3', :text => 'Últimos eventos'
      within 'ul' do
      end
    end
  end

end
#encoding: UTF-8

require 'spec_helper'

feature "Proposal page" do
  background do
    @proposal = Proposal.first
  end

  scenario "shows proposal's title, subtitle and body" do
    visit proposal_path(@proposal)

    within '#proposal' do
      within '.title_author_and_comments' do
        page.should have_css 'blockquote h1', :text => 'Actualizar la información publicada sobre las ayudas a familias numerosas'
        page.should have_content 'María González Pérez'
        page.should have_content 'Un comentario · 53% a favor (de 123)'
        page.should have_link 'María González Pérez'
        page.should have_link 'Un comentario'
      end
      page.should have_css '.title_author_and_comments', :text => /hace menos de 1 minuto/
      within '.content' do
        page.should have_content String.lorem
        within '.in_favor' do
          page.should have_css 'h4', :text => 'A favor'
          page.should have_css 'ul li', :count => 5, :text => String.lorem.truncate(255)
          page.should have_link 'Añadir'
        end
        within '.against' do
          page.should have_css 'h4', :text => 'En contra'
          page.should have_css 'ul li', :count => 5, :text => String.lorem.truncate(255)
          page.should have_link 'Añadir'
        end
      end
    end
  end

  context 'being a registered user' do
    before do
      login_as_regular_user
    end

    scenario "allows me to vote for a proposal" do
      visit proposal_path(@proposal)

      within '#your_opinion' do
        page.should have_css 'h3', :text => '¿Qué opinas tú?'
        page.should have_content 'Dinos si estás a favor o en contra de esta propuesta. Tendremos en cuenta los resultados a la hora de tomar una decisión.'

        page.should have_button 'Votar a favor'
        page.should have_button 'Votar en contra'
        expect{ click_button 'Votar en contra'}.to change{ @proposal.arguments.against.count }.by(1)
      end
    end
  end

  context 'not being a registered user' do
    scenario "doesn't allow me to vote for a proposal" do
      pending 'show login user screen and then allows again to submit the form'
    end
  end

  scenario "has a sidebar with sharing links, a list of tags and related people and news" do
    visit proposal_path(@proposal)
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
    within '.related_content' do
      page.should have_css 'h3', :text => 'Últimos contenidos'
      within 'ul' do
      end
    end
  end

end
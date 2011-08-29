#encoding: UTF-8

require 'spec_helper'

feature "Moderation admin page" do
  background do
    login_as_administrator
  end

  scenario "shows a list of not-moderated contents and participations" do
    visit admin_moderation_path

    within 'div.contents' do
      page.should have_css 'h1', :text => 'Contenidos'
      page.should have_button 'Validar todos'

      page.should have_css 'ul li.content', :count => 22
      within 'ul li.content' do
        page.should have_css 'div.proposal p.title', :text => 'Actualizar la información publicada sobre las ayudas a familias numerosas'
        page.should have_button 'Validar Propuesta'
        page.should have_button 'Eliminar Propuesta'
      end
    end
    within 'div.participations' do
      page.should have_css 'h1', :text => 'Participación'
      page.should have_button 'Validar todos'

      page.should have_css 'ul li.participation', :count => 133
      within 'ul li.participation' do
        page.should have_css 'div.comment p', :text => String.lorem
        page.should have_css 'img'
        page.should have_css 'span', :text => 'Comentado por Andrés Berzoso Rodríguez hace menos de 1 minuto'
        page.should have_link 'Andrés Berzoso Rodríguez'
        page.should have_button 'Validar Comentario'
        page.should have_button 'Eliminar Comentario'
      end
    end
  end

  scenario "allows to moderate items one by one" do
    visit admin_moderation_path

    within 'div.contents' do
      within 'ul li.content' do
        expect{ click_button 'Validar Propuesta'}.to change{ Content.not_moderated.count }.by(-1)
      end
    end

    within 'div.participations' do
      within 'ul li.participation' do
        expect{ click_button 'Validar Comentario'}.to change{ Participation.not_moderated.count }.by(-1)
      end
    end
  end

  scenario "allows to moderate all items at a time" do
    visit admin_moderation_path

    within 'div.contents' do
      expect{ click_button 'Validar todos'}.to change{ Content.not_moderated.count }.to(0)
    end

    within 'div.participations' do
      expect{ click_button 'Validar todos'}.to change{ Participation.not_moderated.count }.to(0)
    end
  end

  scenario "allows to delete items" do
    visit admin_moderation_path

    within 'div.contents' do
      within 'ul li.content' do
        expect{ click_button 'Eliminar Propuesta'}.to change{ Content.count }.by(-1)
      end
    end

    within 'div.participations' do
      within 'ul li.participation' do
        expect{ click_button 'Eliminar Comentario'}.to change{ Participation.count }.by(-1)
      end
    end
  end
end
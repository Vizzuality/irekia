#encoding: UTF-8

require 'spec_helper'

feature "Question page" do
  background do
    validate_all_not_moderated
  end

  context 'for not answered questions' do
    before do
      @question = Question.not_answered.first
    end

    scenario "shows question's title and author" do
      visit question_path(@question)

      within '#question' do
        within '.question_content' do
          page.should have_css 'h1', :text => '¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?'
          within '.author_and_comments' do
            page.should have_content 'María González Pérez'
            page.should have_content ' · Un comentario · No contestada, solicitada por 3'
            page.should have_link 'María González Pérez'
            page.should have_link 'Un comentario'
          end
          page.should have_css '.author_and_comments', :text => /hace (menos de )?\d+ minuto(s)?/
        end
      end
    end

    context 'being a registered user' do
      before do
        login_as_regular_user
      end

      scenario "allows me to request an answer for that question" do
        visit question_path(@question)

        within '.answer_requests' do
          within 'form' do
            page.should have_button 'Solicitar respuesta'
            expect{ click_button 'Solicitar respuesta'}.to change{@question.answer_requests.count}.by(1)
          end
        end
      end
    end

    context 'not being a registered user' do

      scenario "ask me to login and then allows me to request an answer for that question" do
        visit question_path(@question)

        within '.answer_requests' do
          within 'form' do
            page.should have_button 'Solicitar respuesta'
            pending 'show login form and then allow the user to request an answer'
          end
        end
      end

    end

  end

  context 'for answered questions' do
    before do
      @question = Question.answered.first
    end

    scenario "shows question's title and author, and answer's author and the answer itself" do
      visit question_path(@question)

      within '#question' do
        within '.question_content' do
          page.should have_css 'h1', :text => 'Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos.'
          within '.author_and_comments' do
            page.should have_content 'María González Pérez'
            page.should have_content ' · Ningún comentario · '
            page.should have_link 'María González Pérez'
            page.should have_link 'Ningún comentario'
          end
          page.should have_css '.author_and_comments', :text => /hace (menos de )?\d+ minuto(s)?/
          page.should have_css '.author_and_comments', :text => /Contestada tras (menos de )?\d+ minuto(s)?/
        end

        within '.answer' do
          within '.author' do
            page.should have_css 'img'
            page.should have_content 'Ha contestado Virginia Uriarte Rodríguez'
            page.should have_link 'Virginia Uriarte Rodríguez'
            page.should have_css '.title', :text => 'Consejera'
          end
          page.should have_css '.text', :text => 'Hola María, en realidad no va a haber ayuda este año. El recorte este'
        end
      end
    end

    context 'being a registered user' do
      before do
        login_as_regular_user
      end

      scenario "allows me to vote the answer" do
        visit question_path(@question)

        within '#question .answer' do
          page.should have_content '¿Qué te parece la respuesta?'
          page.should have_button 'Satisfactoria'
          page.should have_button 'No satisfactoria'
          expect{ click_button 'Satisfactoria'}.to change{ @question.answer.answer_opinions.satisfactory.count }.by(1)
        end

        within '#question .answer' do
          page.should_not have_button 'Satisfactoria'
          page.should_not have_button 'No satisfactoria'
          page.should have_css 'span', :text => 'Satisfactoria'
          page.should have_css 'span', :text => 'No satisfactoria'
        end
      end
    end

    context 'not being a registered user' do

      scenario "ask me to login and then allows me to vote the answer" do
        visit question_path(@question)

        within '#question .answer' do
          page.should have_content '¿Qué te parece la respuesta?'
          page.should have_button 'Satisfactoria'
          page.should have_button 'No satisfactoria'
          pending 'show login form and then allow the user to vote the answer'
          expect{ click_button 'Satisfactoria'}.to change{ @question.answer.answer_opinions.satisfactory.count }.by(1)
        end
        within '#question .answer' do
          page.should_not have_button 'Satisfactoria'
          page.should_not have_button 'No satisfactoria'
          page.should have_css 'span', :text => 'Satisfactoria'
          page.should have_css 'span', :text => 'No satisfactoria'
        end
      end

    end

  end

  context 'for both'
    before do
      @question = Question.all.sample
    end

    scenario "has a sidebar with sharing links, a list of tags and related people and news" do
      visit question_path(@question)
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
      within '.related_questions' do
        page.should have_css 'h3', :text => 'Otras preguntas similares'
        within 'ul' do
        end
      end
    end

end
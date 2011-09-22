#encoding: UTF-8

require 'spec_helper'

feature "Users" do
  before do
    @user = User.where(:name => 'María', :lastname => 'González Pérez').first
    login_as :email => 'maria.gonzalez@gmail.com', :password => 'maria1234'
  end

  context 'in their personal homepage' do

    scenario "have a dashboard" do
      visit user_path(@user)

      within '.welcome' do
        page.should have_css 'h1', :text => 'Hola María‚ ¿por dónde empezar?'
        page.should have_content 'Actualmente sigues a 5 políticos y 1 área'

        page.should have_css 'ul li', :count => 3
        within 'ul li.follow' do
          page.should have_css 'h3', :text => 'Sigue lo que te interese'
          page.should have_content 'Busca los perfiles o áreas que más te interesen y síguelos.'
          page.should have_content 'De esta manera estarás informado de todo lo que pase con el mínimo esfuerzo.'
          page.should have_link 'Ir a un Área cualquiera'
        end

         within 'ul li.participate' do
          page.should have_css 'h3', :text => 'Participa y aprende'
          page.should have_content 'Haz preguntas a los responsables del Gobierno Vasco, lanza tus propuestas a los ciudadanos, o participa en las propuestas de otros.'
          page.should have_content 'Todo con un simple click.'
          page.should have_link 'Haz preguntas'
          page.should have_link 'lanza tus propuestas'
          page.should have_link 'Crear una pregunta'
        end

          within 'ul li.configure' do
          page.should have_css 'h3', :text => 'Configura tu cuenta'
          page.should have_content 'Sube tu ávatar o modifica tus datos.'
          page.should have_content 'También puedes conectar tus cuentas de facebook y twitter para integrar tu actividad en las redes sociales con el nuevo irekia.'
          page.should have_link 'Configura tu cuenta'
        end

    end

     visit user_path(@user)

      within '.welcome' do
        page.should have_css 'h1', :text => "Hola de nuevo María,"
        page.should have_content 'Actualmente sigues a 5 políticos y 1 área'
      end

      page.should have_css 'ul.menu li.selected', :text => 'Dashboard'
      page.should have_css 'ul.menu li', :text => 'Tus preguntas'
      page.should have_css 'ul.menu li', :text => 'Tus propuestas'
      page.should have_css 'ul.menu li', :text => 'Tu actividad'
      page.should have_css 'ul.menu li', :text => '¿Qué seguir?'
      page.should have_css 'ul.menu li', :text => 'Publicar'


      within '.activity' do
        page.should have_css 'h2', :text => 'Última actividad'
        page.should have_content 'Esta es la actividad relacionada con tus contenidos, o con los perfiles o áreas que sigues.'
        page.should have_link 'perfiles o áreas que sigues'

        page.should have_css 'ul.actions li', :count => 4

        page.should have_css 'a.more_recent', :text => 'Más recientes'
        page.should have_css 'a.more_polemic', :text => 'Más polémica'

        within '.question' do
          page.should have_css 'p', :text => 'Pregunta para el área...'
          page.should have_css 'p.excerpt', :text => '"Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'

          page.should have_css 'img'
          page.should have_css '.footer span.published_at', :text => 'María González Pérez hace alrededor de 1 mes'
          page.should have_css '.footer span.published_at a', :text => 'María González Pérez'
          page.should have_css '.footer a', :text => 'Ningún comentario'
          page.should have_css '.footer a', :text => 'Compartir'
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

        page.should have_css '.pagination', :text => 'ver más acciones'

      end

      within '.follow_suggestions' do
        page.should have_css 'h2', :text => '¿Quieres más? Te sugerimos...'
        page.should have_css 'ul li', :count => 6
        within 'ul li' do
          page.should have_css 'img'
          page.should have_link 'Alberto de Zárate López'
          page.should have_content 'Vice-consejero de Educación, Universidades e Investigación'
          page.should have_link 'Seguir'
        end
        page.should have_link 'Más sugerencias'
      end
    end

    scenario "can see the questions he has made" do
      visit user_path(@user)
      click_link 'Tus preguntas'

      page.should have_css 'ul.menu li', :text => 'Dashboard'
      page.should have_css 'ul.menu li.selected', :text => 'Tus preguntas'
      page.should have_css 'ul.menu li', :text => 'Tus propuestas'
      page.should have_css 'ul.menu li', :text => 'Tu actividad'
      page.should have_css 'ul.menu li', :text => '¿Qué seguir?'
      page.should have_css 'ul.menu li', :text => 'Publicar'

      within '.questions' do

        within '.answered' do
          page.should have_css 'h1', :text => '1 nueva pregunta contestada'

          page.should have_css 'a.more_recent', :text => 'Más recientes'
          page.should have_css 'a.more_commented', :text => 'Más comentadas'

          page.should have_css 'ul li', :count => 1

          within 'ul li' do
            page.should have_css 'p', :text => 'Pregunta para el área...'
            page.should have_css 'p.excerpt', :text => '"Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'

            page.should have_css 'img'
            page.should have_css '.footer span.published_at', :text => 'María González Pérez hace alrededor de 1 mes'
            page.should have_css '.footer span.published_at a', :text => 'María González Pérez'
            page.should have_css '.footer a', :text => 'Ningún comentario'
            page.should have_css '.footer a', :text => 'Compartir'
          end
        end

        within '.all_my_questions' do
          page.should have_css 'h1', :text => '1 nueva pregunta contestada'

          page.should have_css 'a.more_recent', :text => 'Más recientes'
          page.should have_css 'a.more_commented', :text => 'Más comentadas'

          page.should have_css 'ul li', :count => 2
        end

     end
    end

    scenario "can see the proposals he has created" do
      visit user_path(@user)
      click_link 'Tus propuestas'

      page.should have_css 'ul.menu li', :text => 'Dashboard'
      page.should have_css 'ul.menu li', :text => 'Tus preguntas'
      page.should have_css 'ul.menu li.selected', :text => 'Tus propuestas'
      page.should have_css 'ul.menu li', :text => 'Tu actividad'
      page.should have_css 'ul.menu li', :text => '¿Qué seguir?'
      page.should have_css 'ul.menu li', :text => 'Publicar'

      pending "Waiting for the wireframe"
    end

    scenario "can see the activity he has generated" do
      visit user_path(@user)
      click_link 'Tu actividad'

      page.should have_css 'ul.menu li', :text => 'Dashboard'
      page.should have_css 'ul.menu li', :text => 'Tus preguntas'
      page.should have_css 'ul.menu li', :text => 'Tus propuestas'
      page.should have_css 'ul.menu li.selected', :text => 'Tu actividad'
      page.should have_css 'ul.menu li', :text => '¿Qué seguir?'
      page.should have_css 'ul.menu li', :text => 'Publicar'

      within '.activity' do
        page.should have_css 'h2', :text => 'Última actividad'
        page.should have_content 'Esta es la actividad relacionada con tus contenidos, o con los perfiles o áreas que sigues.'
        page.should have_link 'perfiles o áreas que sigues'

        page.should have_css 'ul.actions li', :count => 4

        page.should have_css 'a.more_recent', :text => 'Más recientes'
        page.should have_css 'a.more_polemic', :text => 'Más polémica'

        within '.question' do
          page.should have_css 'p', :text => 'Pregunta para el área...'
          page.should have_css 'p.excerpt', :text => '"Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'

          page.should have_css 'img'
          page.should have_css '.footer span.published_at', :text => 'María González Pérez hace alrededor de 1 mes'
          page.should have_css '.footer span.published_at a', :text => 'María González Pérez'
          page.should have_css '.footer a', :text => 'Ningún comentario'
          page.should have_css '.footer a', :text => 'Compartir'
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

        page.should have_css '.pagination', :text => 'ver más acciones'

      end
    end

    scenario "can see more people to follow" do
      visit user_path(@user, :section => 'people_to_follow')
      click_link '¿Qué seguir?'

      page.should have_css 'ul.menu li', :text => 'Dashboard'
      page.should have_css 'ul.menu li', :text => 'Tus preguntas'
      page.should have_css 'ul.menu li', :text => 'Tus propuestas'
      page.should have_css 'ul.menu li', :text => 'Tu actividad'
      page.should have_css 'ul.menu li.selected', :text => '¿Qué seguir?'
      page.should have_css 'ul.menu li', :text => 'Publicar'

      within '.people_to_follow' do
        page.should have_css 'h2', :text => '¿Quieres más? Te sugerimos...'
        page.should have_css 'ul li', :count => 6
        within 'ul li' do
          page.should have_css 'img'
          page.should have_link 'Alberto de Zárate López'
          page.should have_content 'Vice-consejero de Educación, Universidades e Investigación'
          page.should have_link 'Seguir'
        end
        page.should have_link 'Más sugerencias'
      end
    end

    scenario "can publish more contents" do
      visit user_path(@user)

      click_link 'Publicar'

      within '.publish' do
        page.should have_css 'h1', :text => 'Publicar'
        page.should have_content 'Elige el tipo de contenido, y compártelo con el resto de los usuarios'

        page.should have_css 'ul li', :count => 2
        page.should have_css 'ul li a.question.selected'

        within 'form' do
          fill_in 'Introduce aquí la pregunta que quieras realizar. Recuerda ser breve y conciso.', :with => 'universidad'
          check 'facebook'
          check 'twitter'

          click_button 'Continuar'
        end

        page.should have_content 'Preguntas parecidas'
        page.should have_css 'ul.existing_questions li', :count => 2

        within 'ul.existing_questions' do
          page.should have_css 'li img'
          page.should have_css 'li h4', :text => 'asdf'
          page.should have_css 'li span.author', :text => 'María hace 1 minuto Aún no contestada'
        end

        click_button 'Continuar'

        within 'form' do

          page.should have_content '¿A quién le quieres dirigir la pregunta?'
          fill_in 'Buscar por nombre', :with => 'Virginia Uriarte Rodríguez'

          expect{ click_button 'Publicar'}.to change{ Question.not_moderated.count }.by(1)

        end

        within '.success' do
          page.should have_content 'Tu pregunta ha sido enviada'
          page.should have_content 'En cuanto nuestros moderadores la aprueben, te notificaremos su publicación mediante email.'
        end

      end
    end

    scenario "can edit his settings" do
      visit user_path(@user)

      click_link 'Configura tu cuenta'

      within '.settings' do
        within '.your_profile' do
          page.should have_css 'h1', :text => 'Tu perfil'
          page.should have_content 'Recuerda que son datos públicos y visibles en Irekia.'

          within 'form' do
            check 'Hombre'
            fill_in 'Nombre', :with => 'Mikel'
            fill_in 'Apellidos', :with => 'Aranburu'
            select 'Vizcaya', :in => 'Territorio'
            select 'Bilbao', :in => 'Municipio'
            select '23', :in => 'Day'
            select 'Septiembre', :in => 'Month'
            select '1988', :in => 'Year'

            page.should have_content 'Conexiones con redes sociales'
            expect{ click_button 'facebook' }.to change{ @user.connected_with_facebook? }.to(true)
            expect{ click_button 'twitter' }.to change{ @user.connected_with_twitter? }.to(true)

            click_button 'Guardar cambios'

          end
        end
      end

      within '.your_avatar' do
        page.should have_css 'img'
        page.should have_css 'h3', :text => 'Selecciona tu avatar'
        page.should have_content 'Necesitas una imagen que te represente en Irekia. Los usuarios con avatar son más populares.'
        page.should have_content 'Tamaño máximo 500x500.'

        current_image = @user.pprofile_image

        click_link 'Subir una nueva imagen'

        @user.reload.profile_image.should_not be == current_image
      end

      within '.your_notifications' do
        page.should have_content 'Notificaciones'

        page.should have_button 'Mínimas'
        page.should have_button 'Básicas', :class => 'selected'
        page.should have_button 'Todas'

        click_button 'Todas'
      end

      within '.your_notifications' do
        page.should_not have_button 'Básicas', :class => 'selected'
        page.should have_button 'Todas', :class => 'selected'
      end

      within '.your_avatar' do
        page.should have_css 'h1', :text => 'Configuración de tu cuenta'
        page.should have_content 'Datos de acceso a Irekia'

        within 'form' do
          fill_in 'Tu email', :with => 'test-mail@irekia.com'
          fill_in 'Tu contraseña', :with => '12341234'
          fill_in 'Tu nueva contraseña', :with => '43214321'

          click_button 'Guardar cambios'

        end

        click_link 'Salir'

        login_as :name => @user.name, :password => '43214321'

        page.should have_link 'Salir'

      end
    end

  end

end

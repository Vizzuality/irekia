#encoding: UTF-8

#############################
# AREAS

area = Area.find_or_create_by_name('Educación, Universidades e Investigación')
area.update_attribute(:description, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')

print '.'.blue

# END - AREAS
#############################

#############################
# USERS
women_images = %w(woman.jpeg).map{|image_name| File.open(Rails.root.join('db', 'seeds', 'test_data', 'images', image_name))}
men_images   = %w(man.jpeg).map{|image_name| File.open(Rails.root.join('db', 'seeds', 'test_data', 'images', image_name))}

admin = User.find_or_initialize_by_name_and_email('Administrator', 'admin@example.com')
admin.password = 'example'
admin.password_confirmation = 'example'
admin.role = Role.find_by_name('Administrador')
admin.save!

print '.'.blue

alberto = User.find_or_initialize_by_name_and_email('Alberto de Zárate López', 'alberto.zarate@ej-gv.es')
alberto.description = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
alberto.role = Role.find_by_name('Político')
alberto.areas.clear
alberto.areas_users << AreaUser.create(:area => area, :display_order => 2)
alberto.title = Title.find_by_name('Vice-consejero')
alberto.profile_pictures << Image.create(:image => men_images.sample)
alberto.save(:validate => false)

print '.'.blue

virginia = User.find_or_initialize_by_name_and_email('Virginia Uriarte Rodríguez', 'virginia.uriarte@ej-gv.es')
virginia.is_woman = true
virginia.description = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
virginia.role = Role.find_by_name('Político')
virginia.areas.clear
virginia.areas_users << AreaUser.create(:area => area, :display_order => 1)
virginia.title = Title.find_by_name('Consejero')
virginia.profile_pictures << Image.create(:image => women_images.sample)
virginia.save(:validate => false)

print '.'.blue

3.times do
  name = "#{String.random(20)} #{String.random(20)} #{String.random(20)}"
  user = User.find_or_initialize_by_name_and_email(name, "#{name.downcase.split(' ').join('.')}@ej-gv.es")
  user.is_woman = [true, false].sample
  user.inactive = [true, false].sample
  user.description = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
  user.role = Role.find_by_name('Político')
  user.areas.clear
  user.areas << area
  user.title = Title.find_by_name('Vice-consejero')
  user.profile_pictures << Image.create(:image => (men_images + women_images).sample)
  user.save(:validate => false)

  print '.'.blue

end

maria = User.find_or_initialize_by_name_and_email('María González Pérez', 'maria.gonzalez@gmail.com')
maria.profile_pictures << Image.create(:image => women_images.sample)
maria.save(:validate => false)

print '.'.blue

andres = User.find_or_initialize_by_name_and_email('Andrés Berzoso Rodríguez', 'andres.berzoso@gmail.com')
andres.profile_pictures << Image.create(:image => men_images.sample)
andres.save(:validate => false)

print '.'.blue

aritz = User.find_or_initialize_by_name_and_email('Aritz Aranburu', 'aritz.aranburu@gmail.com')
aritz.profile_pictures << Image.create(:image => men_images.sample)
aritz.save(:validate => false)

print '.'.blue

# END - USERS
#############################
Event.create(
  :users => [virginia],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 1, :hours => 10)}
)

print '.'.blue

Event.create(
  :users => [virginia],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 1, :hours => 12)}
)

print '.'.blue

Event.create(
  :users => [virginia],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 3, :hours => 15)}
)

print '.'.blue

Event.create(
  :users => [virginia],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 10, :hours => 9)}
)

print '.'.blue

Event.create(
  :users => [alberto],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 1, :hours => 10)}
)

print '.'.blue

Event.create(
  :users => [alberto],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 2, :hours => 12)}
)

print '.'.blue

Event.create(
  :users => [alberto],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 3, :hours => 15)}
)

print '.'.blue

Event.create(
  :users => [alberto],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 3, :hours => 18)}
)

print '.'.blue

Event.create(
  :users => [alberto],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 9, :hours => 9)}
)

print '.'.blue

Event.create(
  :users => [alberto],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 9, :hours => 11)}
)

print '.'.blue

Event.create(
  :users => [alberto],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 9, :hours => 16)}
)

print '.'.blue

Event.create(
  :users => [alberto],
  :areas => [area],
  :the_geom => 'POINT(-2.937952 43.270214)',
  :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.current.beginning_of_week.advance(:days => 11, :hours => 12)}
)

print '.'.blue

proposal_data = ProposalData.find_or_initialize_by_proposal_text('Actualizar la información publicada sobre las ayudas a familias numerosas')

if proposal_data.new_record?
  proposal_data.target_user = virginia

  proposal = Proposal.new
  proposal.areas << area
  proposal.users << maria
  proposal.proposal_data = proposal_data
  proposal.comments << andres.comments.new.create_with_body('Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')

  proposal.save!
end

print '.'.blue

question_data = QuestionData.find_or_initialize_by_question_text('¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?')

if question_data.new_record?
  question = Question.new
  question.areas << area
  question.users << maria
  question_data.target_user = virginia
  question.question_data = question_data
  question.comments << andres.comments.new.create_with_body('Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')

  question.save!
end

print '.'.blue

proposal_data = ProposalData.find_by_proposal_text('Actualizar la información publicada sobre las ayudas a familias numerosas')

proposal = proposal_data.proposal
proposal.arguments.clear

argument = Argument.new
argument.user = aritz
argument.proposal = proposal_data.proposal

argument.save!

print '.'.blue


area_question_data = QuestionData.find_or_initialize_by_question_text('Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos.')

if area_question_data.new_record?
  area_question_data.target_area = area

  question = Question.new
  question.areas << area
  question.users << maria
  question.question_data = area_question_data

  question.save!
end

print '.'.blue

news_data = NewsData.find_or_initialize_by_title('Inauguración del nuevo complejo deportivo en la localidad de Getxo')

if news_data.new_record?
  news_data.subtitle = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
  news_data.body = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
  news = News.new
  news.tags = %w(Comisión Transporte Gobierno\ Vasco Transporte).join(',')
  news.areas << area
  news.users << virginia
  news.news_data = news_data
  news.comments << maria.comments.new.create_with_body(<<-EOF
    Me encantaría que realmente esta gente fuera siempre a los eventos y nos lo comunicaran como en esta ocasión. La verdad que fue un buen momento para hablar con ellos y conocerlos en persona.
  EOF
  )
  news.comments << alberto.comments.new.create_with_body(<<-EOF
    Yo estuve allí y la verdad es que no fue gran cosa...
  EOF
  )

  news.save!
end

print '.'.blue

answer_data = AnswerData.find_or_initialize_by_answer_text('Hola María, en realidad no va a haber ayuda este año. El recorte este')

if answer_data.new_record?

  answer_data.author = virginia
  answer_data.question = question

  answer = Answer.new
  answer.areas << area
  answer.users << virginia
  answer.answer_data = answer_data
  answer.comments << maria.comments.new.create_with_body('Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')

  answer.save!
end

print '.'.blue

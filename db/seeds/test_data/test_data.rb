#encoding: UTF-8

#############################
# AREAS

area = Area.find_or_create_by_name('Educación, Universidades e Investigación')

# END - AREAS
#############################

#############################
# USERS

puts 'Loading politics...'
alberto = User.find_or_initialize_by_name_and_email('Alberto de Zárate López', 'alberto.zarate@ej-gv.es')
alberto.description = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
alberto.role = Role.find_by_name('Político')
alberto.areas.clear
alberto.areas_users << AreaUser.create(:area => area, :display_order => 2)
alberto.title = Title.find_by_name('Vice-consejero')
alberto.save(:validate => false)

Delorean.time_travel_to Time.current.beginning_of_week.advance(:days => 1) do
  Event.create(
    :users => [alberto],
    :areas => [area],
    :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.now}
  )
end
Delorean.time_travel_to Time.current.beginning_of_week.advance(:days => 2) do
  Event.create(
    :users => [alberto],
    :areas => [area],
    :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.now}
  )
end
Delorean.time_travel_to Time.current.beginning_of_week.advance(:days => 3) do
  Event.create(
    :users => [alberto],
    :areas => [area],
    :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.now}
  )
  Event.create(
    :users => [alberto],
    :areas => [area],
    :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.now}
  )
end
Delorean.time_travel_to Time.current.beginning_of_week.advance(:days => 9) do
  Event.create(
    :users => [alberto],
    :areas => [area],
    :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.now}
  )
  Event.create(
    :users => [alberto],
    :areas => [area],
    :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.now}
  )
  Event.create(
    :users => [alberto],
    :areas => [area],
    :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.now}
  )
end
Delorean.time_travel_to Time.current.beginning_of_week.advance(:days => 11) do
  Event.create(
    :users => [alberto],
    :areas => [area],
    :event_data_attributes => {:subject => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :event_date => Time.now}
  )
end



virginia = User.find_or_initialize_by_name_and_email('Virginia Uriarte Rodríguez', 'virginia.uriarte@ej-gv.es')
virginia.description = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
virginia.role = Role.find_by_name('Político')
virginia.areas.clear
virginia.areas_users << AreaUser.create(:area => area, :display_order => 1)
virginia.title = Title.find_by_name('Consejero')
virginia.save(:validate => false)


3.times do
  name = "#{String.random(20)} #{String.random(20)} #{String.random(20)}"
  user = User.find_or_initialize_by_name_and_email(name, "#{name.downcase.split(' ').join('.')}@ej-gv.es")
  user.description = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
  user.role = Role.find_by_name('Político')
  user.areas.clear
  user.areas << area
  user.title = Title.find_by_name('Vice-consejero')
  user.save(:validate => false)
end

puts '...done!'

puts ''

puts 'Loading regular testing users...'
maria = User.find_or_initialize_by_name_and_email('María González Pérez', 'maria.gonzalez@gmail.com')
maria.save(:validate => false)
andres = User.find_or_initialize_by_name_and_email('Andrés Berzoso Rodríguez', 'andres.berzoso@gmail.com')
andres.save(:validate => false)
aritz = User.find_or_initialize_by_name_and_email('Aritz Aranburu', 'aritz.aranburu@gmail.com')
aritz.save(:validate => false)
puts '...done!'

# END - USERS
#############################


puts 'Loading proposals...'

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

puts '...done!'

puts ''

puts 'Loading questions...'

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

puts '...done!'

puts ''

puts 'Loading arguments...'

proposal_data = ProposalData.find_by_proposal_text('Actualizar la información publicada sobre las ayudas a familias numerosas')

proposal = proposal_data.proposal
proposal.arguments.clear

argument = Argument.new
argument.user = aritz
argument.proposal = proposal_data.proposal

argument.save!

puts '...done!'

puts ''

puts 'Loading area questions...'

area_question_data = QuestionData.find_or_initialize_by_question_text('Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos.')

if area_question_data.new_record?
  area_question_data.target_area = area

  question = Question.new
  question.areas << area
  question.users << maria
  question.question_data = area_question_data

  question.save!
end

puts '...done!'

puts ''


puts 'Loading news...'

news_data = NewsData.find_or_initialize_by_title('Inauguración del nuevo complejo deportivo en la localidad de Getxo')

if news_data.new_record?
  news_data.body = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

  news = News.new
  news.areas << area
  news.users << virginia
  news.news_data = news_data

  news.save!
end

puts '...done!'

puts ''


puts 'Loading answers...'

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

puts '...done!'

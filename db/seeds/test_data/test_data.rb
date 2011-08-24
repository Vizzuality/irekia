#encoding: UTF-8

#############################
# AREAS
area = Area.find_or_create_by_name('Educación, Universidades e Investigación')
area.update_attribute(:description, String.lorem)

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
alberto.description = String.lorem
alberto.role = Role.find_by_name('Político')
alberto.areas.clear
alberto.areas_users << AreaUser.create(:area => area, :display_order => 2)
alberto.title = Title.find_by_name('Vice-consejero')
alberto.profile_pictures << Image.create(:image => men_images.sample)
alberto.save(:validate => false)

print '.'.blue

virginia = User.find_or_initialize_by_name_and_email('Virginia Uriarte Rodríguez', 'virginia.uriarte@ej-gv.es')
virginia.is_woman = true
virginia.description = String.lorem
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
  user.description = String.lorem
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

User.find_or_create_by_name :name                  => 'José López Pérez',
                            :email                 => 'pepito@irekia.com',
                            :password              => 'irekia1234',
                            :password_confirmation => 'irekia1234'

print '.'.blue

# END - USERS
#############################
proposal_data = ProposalData.find_or_initialize_by_title('Actualizar la información publicada sobre las ayudas a familias numerosas')

if proposal_data.new_record?
  proposal_data.body = String.lorem
  proposal_data.target_user = virginia

  proposal = Proposal.new
  proposal.tags = %w(Comisión Transporte Gobierno\ Vasco Transporte).join(',')
  proposal.areas << area
  proposal.users << maria
  proposal.proposal_data = proposal_data
  proposal.comments << andres.comments.new.create_with_body(String.lorem)

  proposal.save!

  65.times do

    argument = Argument.new
    argument.user     = [andres, aritz, maria].sample
    argument.proposal = proposal_data.proposal
    argument.argument_data = ArgumentData.create :reason => String.lorem.truncate(255)

    argument.save!

    print '.'.blue
  end

  57.times do
    argument = Argument.new
    argument.user     = [andres, aritz, maria].sample
    argument.proposal = proposal_data.proposal
    argument.argument_data = ArgumentData.create :in_favor => false,  :reason => String.lorem.truncate(255)

    argument.save!

    print '.'.blue
  end

end

print '.'.blue


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


# Tweets
Tweet.create :users => [maria],
             :tweet_data => TweetData.find_or_create_by_message('Saliendo para el Euskal Encounter. Muchas ganas de asistir la charla de @alorza sobre Open Data', :status_id => '000000000000000000000', :username => 'magope')
Tweet.create :users => [maria],
             :tweet_data => TweetData.find_or_create_by_message('Preparando lo de mañana en el Euskal Encounter', :status_id => '111111111111111111111', :username => 'magope')
Tweet.create :users => [maria],
             :tweet_data => TweetData.find_or_create_by_message('Vuelta de vacaciones. Grr.', :status_id => '222222222222222222222', :username => 'magope')
Tweet.create :users => [maria],
             :tweet_data => TweetData.find_or_create_by_message('#dearlazyweb, ¿un restaurante en Puerto de Santa María?', :status_id => '333333333333333333333', :username => 'magope')

# Photos
image = Image.create :image => men_images.sample,
                     :title => 'Presentación del Gobierno Vasco 2010',
                     :description => 'Presentación del Nuevo Gobierno Vasco, formado tras las elecciones de 2010'

Photo.create :image    => image,
             :tags     => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(','),
             :users    => [virginia],
             :comments => [
                maria.comments.new.create_with_body(<<-EOF
                  Me encantaría que realmente esta gente fuera siempre a los eventos y nos lo comunicaran como en esta ocasión. La verdad que fue un buen momento para hablar con ellos y conocerlos en persona.
                EOF
                ),
                alberto.comments.new.create_with_body(<<-EOF
                  Yo estuve allí y la verdad es que no fue gran cosa...
                EOF
                )
             ]

print '.'.blue

# Question

question_data = QuestionData.find_or_initialize_by_question_text('¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?')

if question_data.new_record?
  question = Question.new
  question.areas << area
  question.users << maria
  question_data.target_user = virginia
  question.question_data = question_data
  question.comments << andres.comments.new.create_with_body(String.lorem)
  question.tags = %w(Comisión Transporte Gobierno\ Vasco Transporte).join(',')

  question.save!

  [andres, aritz, maria].each do |user|
    question.answer_requests.create :user => user
  end
end

print '.'.blue

area_question_data = QuestionData.find_or_initialize_by_question_text('Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos.')

if area_question_data.new_record?
  area_question_data.target_area = area

  question = Question.new
  question.areas << area
  question.users << maria
  question.question_data = area_question_data
  question.tags = %w(Comisión Transporte Gobierno\ Vasco Transporte).join(',')

  question.save!
end

print '.'.blue

news_data = NewsData.find_or_initialize_by_title('Inauguración del nuevo complejo deportivo en la localidad de Getxo')

if news_data.new_record?
  news_data.subtitle = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
  news_data.body = String.lorem
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
  answer.comments << maria.comments.new.create_with_body(String.lorem)

  answer.save!
end

print '.'.blue

argument = Argument.new
argument.user     = aritz
argument.proposal = ProposalData.find_by_title('Actualizar la información publicada sobre las ayudas a familias numerosas').proposal
argument.argument_data = ArgumentData.create :reason => String.lorem.truncate(255)

argument.save!

print '.'.blue

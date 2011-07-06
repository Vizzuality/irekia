#encoding: UTF-8

area     = Area.find_by_name('Educación, Universidades e Investigación')
virginia = User.find_by_name('Virginia Uriarte Rodríguez')
maria    = User.find_by_name('María González Pérez')
andres   = User.find_by_name('Andrés Berzoso Rodríguez')
aritz    = User.find_by_name('Aritz Aranburu')

puts 'Loading proposals...'

proposal_data = ProposalData.find_or_initialize_by_proposal_text('Actualizar la información publicada sobre las ayudas a familias numerosas')

if proposal_data.new_record?
  proposal_data.target_user = virginia

  proposal = Proposal.new
  proposal.areas << area
  proposal.users << maria
  proposal.proposal_data = proposal_data

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

  question.save!
end

puts '...done!'

puts ''

puts 'Loading arguments...'

proposal_data = ProposalData.find_or_initialize_by_proposal_text('Actualizar la información publicada sobre las ayudas a familias numerosas')

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

  answer.save!
end

puts '...done!'

#encoding: UTF-8

area     = Area.find_by_name('Educación, Universidades e Investigación')
virginia = User.find_by_name_and_lastname('Virginia', 'Uriarte Rodríguez')
maria    = User.find_by_name_and_lastname('María', 'González Pérez')
andres   = User.find_by_name_and_lastname('Andrés', 'Berzoso Rodríguez')
aritz    = User.find_by_name_and_lastname('Aritz', 'Aranburu')

puts 'Loading proposals...'
proposal = Proposal.find_or_initialize_by_title('Actualizar la información publicada sobre las ayudas a familias numerosas')
if proposal.new_record?
  proposal.areas << area
  proposal.authors << maria

  proposal.save!
end
puts '...done!'

puts ''

puts 'Loading questions...'

question = Question.find_or_initialize_by_title('¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?')
if question.new_record?
  question.areas << area
  question.authors << maria
  question.receivers << virginia

  question.save!
end
puts '...done!'

puts ''

puts 'Loading arguments...'
argument = Argument.find_or_initialize_by_title('Argumento a favor de prueba')
if argument.new_record?
  argument.areas << area
  argument.authors << aritz
  argument.proposal = proposal
  argument.status = ContentStatus.in_favor

  argument.save!
end
puts '...done!'

puts ''

puts 'Loading area questions...'
area_question = Question.find_or_initialize_by_title('Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos.')
if question.new_record?
  question.areas << area
  question.authors << andres

  area_question.save!
end
puts '...done!'

puts ''


puts 'Loading news...'
news = News.find_or_initialize_by_title('Inauguración del nuevo complejo deportivo en la localidad de Getxo')
if news.new_record?
  news.body = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
  news.areas << area
  news.authors << virginia
  news.save!
end
puts '...done!'

puts ''

puts 'Loading answers...'
answer = Answer.find_or_initialize_by_title('¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?')
if answer.new_record?
  answer.body = 'Hola María, en realidad no va a haber ayuda este año. El recorte este'
  answer.question = question
  answer.areas << area
  answer.authors << virginia
  answer.receivers << maria

  answer.save!
end
puts '...done!'

puts ''

puts 'Loading proposals...'
# create_proposal(:area => area)
# create_proposal(:area => area, :status => ContentStatus.closed_proposal)
# create_proposal(:area => area, :status => ContentStatus.closed_proposal)
# create_proposal(:area => area)
puts '...done!'

puts ''


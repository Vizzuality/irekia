#encoding: UTF-8

puts 'Loading politics...'
admin = User.find_or_create_by_name_and_lastname('Virginia', 'Uriarte Rodríguez')
admin.role = Role.where_translation(:name => 'Político').first
admin.areas.clear
admin.areas << Area.find_by_name('Educación, Universidades e Investigación')
admin.save!
puts '...done!'

puts ''

puts 'Loading regular testing uses...'
User.find_or_create_by_name_and_lastname('María', 'González Pérez')
User.find_or_create_by_name_and_lastname('Andrés', 'Berzoso Rodríguez')
User.find_or_create_by_name_and_lastname('Aritz', 'Aranburu')
puts '...done!'

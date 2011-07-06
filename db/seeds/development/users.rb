#encoding: UTF-8

puts 'Loading politics...'
admin = User.find_or_initialize_by_name_and_email('Alberto de Zárate López', 'alberto.zarate@ej-gv.es')
admin.role = Role.find_by_name('Político')
admin.areas.clear
admin.areas_users << AreaUser.create(:area => Area.find_by_name('Educación, Universidades e Investigación'), :display_order => 2)
admin.title = Title.find_by_name('Vice-consejero')
admin.save(:validate => false)

admin = User.find_or_initialize_by_name_and_email('Virginia Uriarte Rodríguez', 'virginia.uriarte@ej-gv.es')
admin.role = Role.find_by_name('Político')
admin.areas.clear
admin.areas_users << AreaUser.create(:area => Area.find_by_name('Educación, Universidades e Investigación'), :display_order => 1)
admin.title = Title.find_by_name('Consejero')
admin.save(:validate => false)

puts '...done!'

puts ''

puts 'Loading regular testing users...'
User.find_or_initialize_by_name_and_email('María González Pérez', 'maria.gonzalez@gmail.com').save(:validate => false)
User.find_or_initialize_by_name_and_email('Andrés Berzoso Rodríguez', 'andres.berzoso@gmail.com').save(:validate => false)
User.find_or_initialize_by_name_and_email('Aritz Aranburu', 'aritz.aranburu@gmail.com').save(:validate => false)
puts '...done!'

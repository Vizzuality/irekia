#encoding: UTF-8

# Roles
puts 'Loading roles...'
Role.find_or_create_by_name_and_name_i18n_key('Administrador', 'administrator')
Role.find_or_create_by_name_and_name_i18n_key('Político', 'politic')
Role.find_or_create_by_name_and_name_i18n_key('Ciudadano', 'citizen')
puts '... done!'

puts ''

# Titles
puts 'Loading titles...'
Title.find_or_create_by_name_and_name_i18n_key('Consejero', 'adviser')
Title.find_or_create_by_name_and_name_i18n_key('Vice-consejero', 'co_adviser')
puts '... done!'

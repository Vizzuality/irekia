#encoding: UTF-8

# Roles
puts 'Loading roles...'
Role.find_or_create_by_name_and_translation_key('Administrador', 'name.administrator')
Role.find_or_create_by_name_and_translation_key('Político', 'name.politic')
Role.find_or_create_by_name_and_translation_key('Ciudadano', 'name.citizen')
puts '... done!'

puts ''

# Titles
puts 'Loading titles...'
Title.find_or_create_by_name_and_translation_key('Consejero', 'name.adviser')
Title.find_or_create_by_name_and_translation_key('Vice-consejero', 'name.co_adviser')
puts '... done!'

# Contents statuses
puts 'Loading content statuses...'
ContentStatus.find_or_create_by_name('open')
ContentStatus.find_or_create_by_name('closed')
ContentStatus.find_or_create_by_name('in_favor')
ContentStatus.find_or_create_by_name('against')
puts '... done!'

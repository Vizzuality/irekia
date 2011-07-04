#encoding: UTF-8

# Roles
puts 'Loading roles...'
Role.translations_for :name => 'Administrador' do |role|
  role.add_translation('es', :name => 'Administrador')
  role.add_translation('eu', :name => '')
end
Role.translations_for :name => 'Político' do |role|
  role.add_translation('es', :name => 'Político')
  role.add_translation('eu', :name => '')
end
Role.translations_for :name => 'Ciudadano' do |role|
  role.add_translation('es', :name => 'Ciudadano')
  role.add_translation('eu', :name => '')
end
puts '... done!'

puts ''

# Sexes
puts 'Loading sexes...'
Sex.translations_for :name => 'Hombre' do |sex|
  sex.add_translation('es', :name => 'Hombre')
  sex.add_translation('eu', :name => '')
end
Sex.translations_for :name => 'Mujer' do |sex|
  sex.add_translation('es', :name => 'Mujer')
  sex.add_translation('eu', :name => '')
end
puts '... done!'

puts ''

# Sexes
puts 'Loading titles...'
Title.translations_for :name => 'Consejero' do |title|
  title.add_translation('es', :name => 'Consejero')
  title.add_translation('eu', :name => '')
end
Title.translations_for :name => 'Vice-consejero' do |title|
  title.add_translation('es', :name => 'Vice-consejero')
  title.add_translation('eu', :name => '')
end
puts '... done!'

puts ''

# Contents statuses
puts 'Loading content statuses...'
ContentStatus.find_or_create_by_name('open')
ContentStatus.find_or_create_by_name('closed')
ContentStatus.find_or_create_by_name('in_favor')
ContentStatus.find_or_create_by_name('against')
puts '... done!'

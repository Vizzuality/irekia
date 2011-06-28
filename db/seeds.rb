#encoding: UTF-8

# Roles
puts 'Loading roles...'
Role.translations_for :name => 'Administrador' do |role|
  role.add_translation('es', :name => 'Administrador')
  role.add_translation('eu', :name => 'Administrator')
end
Role.translations_for :name => 'Político' do |role|
  role.add_translation('es', :name => 'Político')
  role.add_translation('eu', :name => 'Politika')
end
Role.translations_for :name => 'Ciudadano' do |role|
  role.add_translation('es', :name => 'Ciudadano')
  role.add_translation('eu', :name => 'Herritarren')
end
puts '... done!'

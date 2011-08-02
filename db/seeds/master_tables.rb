#encoding: UTF-8

# Roles
Role.find_or_create_by_name_and_name_i18n_key('Administrador', 'administrator')
Role.find_or_create_by_name_and_name_i18n_key('Político', 'politic')
Role.find_or_create_by_name_and_name_i18n_key('Ciudadano', 'citizen')
puts '=> roles loaded'.blue

# Titles
Title.find_or_create_by_name_and_name_i18n_key('Consejero', 'adviser')
Title.find_or_create_by_name_and_name_i18n_key('Vice-consejero', 'co_adviser')
puts '=> titles loaded'.blue

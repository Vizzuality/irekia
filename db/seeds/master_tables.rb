#encoding: UTF-8

# Roles
Role.find_or_create_by_name_and_name_i18n_key('Administrator', 'administrator')
Role.find_or_create_by_name_and_name_i18n_key('Politic', 'politic')
Role.find_or_create_by_name_and_name_i18n_key('Citizen', 'citizen')
puts '=> roles loaded'.blue

# Titles
Title.find_or_create_by_name_and_name_i18n_key('Adviser', 'adviser')
Title.find_or_create_by_name_and_name_i18n_key('Co-adviser', 'co_adviser')
puts '=> titles loaded'.blue

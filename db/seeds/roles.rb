#encoding: UTF-8

# Roles
Role.find_or_create_by_name_and_name_i18n_key('Administrator', 'administrator')
Role.find_or_create_by_name_and_name_i18n_key('Politician', 'politician')
Role.find_or_create_by_name_and_name_i18n_key('Citizen', 'citizen')
puts '=> roles loaded'

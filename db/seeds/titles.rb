#encoding: UTF-8

# Titles
Title.find_or_create_by_name_and_name_i18n_key('Adviser', 'adviser')
Title.find_or_create_by_name_and_name_i18n_key('Co-adviser', 'co_adviser')
puts '=> titles loaded'.blue

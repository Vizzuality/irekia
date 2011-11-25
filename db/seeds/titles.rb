#encoding: UTF-8

# Titles
Title.find_or_create_by_name('Adviser', :translated_name => {'es' => 'Consejero',
                                                             'eu' => 'Consejero',
                                                             'en' => 'Consejero'})
Title.find_or_create_by_name('Co-adviser', :translated_name => {'es' => 'Viceconsejero',
                                                                'eu' => 'Viceconsejero',
                                                                'en' => 'Viceconsejero'})
puts '=> titles loaded'

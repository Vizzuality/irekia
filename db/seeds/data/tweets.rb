#encoding: UTF-8

puts ''
puts 'Creating tweets...'
puts '=================='

create_tweet :author => @aitana,
             :area => Area.find(3),
             :message => 'Este domingo día 6, MITIN del Lehendakari Patxi López en el Auditorio de Pola de #Siero a las 12 horas. #Rubalcabasi.',
             :username => 'aitamu'

create_tweet :author => @aitana,
             :area => Area.find(3),
             :message => 'Europa Press: López dice que "no es momento" de creer que hay conflicto político',
             :username => 'aitamu'

create_tweet :author => @aitor,
             :area => Area.find(3),
             :message => 'PRESENTACIÓN CANDIDATOS Patxi López insta a la "unidad y la suma de esfuerzos" entre partidos http://fb.me/REOhF5wO',
             :username => 'aitor_garcia'

create_tweet :author => @aitor,
             :area => Area.find(3),
             :message => 'Buena comida con universitarios vascos en la universidad de Deusto',
             :username => 'aitor_garcia'

create_tweet :author => @javier,
             :area => Area.find(3),
             :message => 'Martes día 8, en Talavera-Ferial Acto Joven @conRubalcaba !!!! 12.00 horas en Talavera de la Reina, te vienes??? #RubalcabaSI',
             :username => 'javijimal'

create_tweet :author => @javier,
             :area => Area.find(3),
             :message => 'Este domingo día 6, MITIN del Lehendakari Patxi López en el Auditorio de Pola de #Siero a las 12 horas.',
             :username => 'javijimal'

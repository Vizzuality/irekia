#encoding: UTF-8

puts ''.green
puts 'Creating events...'.green
puts '=================='.green

this_week = Time.current.beginning_of_week

create_event :title    => 'Reunión con el Sindicato de Estudiantes Universitarios',
             :body     => 'El próximo dia 23 de noviembre de 2011. a las 10:00 horas se celebrará una reunión con diversos Sindicatos de la universidad de Deusto. Se tratarán diversos temas entre ellos el reparto económico, los presupuestos de este año así como el nuevo organigrama de la universidad. Se tiene pensado la celebración de una comida con los representantes del Gobierno Vasco así como los dirigentes de los distintos sindicatos estudiantiles. Será un evento abierto para todos aquellos universitarios que quieran pasar por la sala de conferencias, a partir de las 17:00 horas.',
             :location => 'Universidad de Deusto, Camino Mundaiz / Mundaiz Bidea, 50, 20012 San Sebastián',
             :user     => @aitana,
             :date     => this_week.advance(:days => rand(35), :hours => rand(24))

create_event :title    => 'Conferencia sobre del Cambio Climático',
             :body     => 'El próximo 30 de noviembre se celebrará en el Palacio de Congresos de Barakaldo la V conferencia sobre cambio climático. La conferencia contará con la asistencia de famosos cientificos de diferentes universidades. Este año contará con la asistencia del  Premio Nobel de Fisica. Para asistir es necesario acreditación que le podrá ser facilitada poniendose en contacto con nosotros.',
             :location => 'Palacio de Congresos, Ronda de Azkue, 1, Barakaldo',
             :user     => @aitor,
             :date     => this_week.advance(:days => rand(35), :hours => rand(24))

create_event :title    => 'Rueda de Prensa sobre los Presupuestos Generales',
             :body     => 'Con motivo de la presentación de los Presupuestos Generales del próximo año, se celebrará una rueda de prensa el día 15 de octubre de 2011 a las 17 horas en el Palacio de la Presidencia. Se requiere acreditación para poder asistir a dicha rueda de prensa. Al finalizar abriremos una rueda de preguntas y al finalizar esta se celebrará un pequeño catering.',
             :location => 'Palacio de la Presidencia, Avda. Zurriola, 1, San Sebastián',
             :user     => @aitana,
             :date     => this_week.advance(:days => rand(35), :hours => rand(24))

create_event :title    => 'Charlas sobre la Convivencia Multicultural',
             :body     => 'Debido al incremento del número de inmigrantes en nuestro país y por una petición popular se crearon hace unos años estas charlas. Comenzaron siendo de barrio pero han llegado a convertirse en un referente a nivel nacional y son un ejemplo de charlas en las que interactúan  un gran numero de participantes. Este año contamos con la asistencia de mas de 30 conferenciantes de distintas nacionalidades.',
             :location => 'Salon de Actos, Avda Santander 15, Bilbao',
             :user     => @javier,
             :date     => this_week.advance(:days => rand(35), :hours => rand(24))

create_event :title    => 'Entrega de premios de Ciudadania Ejemplar',
             :body     => 'Un año más celebramos los premios Ciudadanía Ejemplar. Este año la entrega de premios se realizará en el Ayuntamiento de Vitoria. La entrega se realizará el 18 de diciembre de 2011 a las 18:00 horas. Contamos con todos vosotros para lograr que sea un éxito. Al finalizar la entrega , tomaremos unos vinos de la tierra cortesía de Bodegas Elorriaga.',
             :location => 'Ayuntamiento de Vitoria',
             :user     => @javier,
             :date     => this_week.advance(:days => rand(35), :hours => rand(24))


#encoding: UTF-8

puts ''.green
puts 'Creating questions...'.green
puts '====================='.green

create_question :text           => '¿Podría decirme cuando tienen pensado finalizar las obras de la calle Libertad?',
                :areas          => [@area],
                :users          => [@andres],
                :for            => @aitana,
                :comments       => [
                  create_comment(@alejandro, 'dijeron que en principio eran unos meses, y ya van camino del año... Esperemos no dure mucho mas, porque tengo que aparcar lejos y cuando me toca venir con la compra no me hace mucha gracia la verdad'),
                  create_comment(@iker, 'seguro que a los pocos meses la vuelven a abrir para cambiar o poner otras cosas...')
                ],
                :tags           => %w(trafico obra ciudadanía).join(','),
                :answer         => {
                  :text     => (<<-EOF
                    En el plazo máximo de 4 meses, la empresa constructora nos confirmo que estaría abierta la calle de nuevo al trafico. Las obras las estamos realizando como mejora del sistema de canalización de agua. Rogamos disculpen los problemas ocasionados tanto a viandantes como vecinos de la zona. Estamos trabajando para la mejora de nuestra ciudad.
                  EOF
                  ),
                  :author   => @aitana,
                  :areas    => [@area],
                  :comments => [
                    create_comment(@alejandro, 'la verdad que se hace cansado el constante ruido al que estamos expuestos. Además del polvo y la suciedad que llevamos sufriendo tantos meses.'),
                    create_comment(@gonzalo, 'Quedará todo genial despues de tantos meses...')
                  ]
                }



create_question :text     => '¿Por qué  es tan dificil jugar al padel en Vizcaya? Llevo varias semanas intentando reservar pista y siempre me encuentro con  que está reservada.',
                :areas    => [@area],
                :users    => [@gonzalo],
                :for      => @aitor,
                :comments => [
                  create_comment(@patricia, 'me gustaría saber si por internet y por telefono se puede reservar o solamente es presencial.  Es dificil jugar al padel, esperemos pongan soluciones pronto.'),
                  create_comment(@andres, 'yo me canso mas intentando reservar pista que luego jugando!!')
                ],
                :tags           => %w(deporte padel polideportivo).join(','),
                :answer         => {
                  :text => (<<-EOF
                    Somos conscientes del creciente aumento del padel en nuestra ciudad. Ya hemos recibido varias quejas y estamos barajando la posibilidad de construir pistas en las afueras de la ciudad con el fin de que todos podamos disfrutar de la practica de padel. Gracias por hacernos llegar vuestras sugerencias.
                  EOF
                  ),
                  :author => @javier,
                  :areas => [@area],
                  :comments => [
                    create_comment(@iker, 'además de poner mas pistas tambien sería un detalle por vuestra parte bajar los precios, porque son algo excesivos la verdad! Seria una forma bastante interesante de fomentar mas el deporte')
                  ]
                }

create_question :text     => 'Llevamos varios meses ya de inseguridad ciudadana y varias decenas de denuncias,  ¿hasta cuando vamos a tener que aguantar la inseguridad que hay en nuestras calles?',
                :areas    => [@area],
                :users    => [@iker],
                :for      => @area,
                :want_an_answer => [@patricia],
                :comments => [
                  create_comment(@gonzalo, 'conozco a varios vecinos que han sufrido amenazas y robos. Al final acabaremos realizando patrullas callejeras, en plan americano.'),
                  create_comment(@patricia, 'la verdad que las calles se están volviendo territorio hostil. Esperemos que nuestras quejas no caigan en saco roto y nos hagan caso. Estoy bastante preocupada por mis hijos'),
                  create_comment(@andres, 'a mi me da miedo salir de noche por la calle. durante el dia pasan algunos coches de policiía pero cuando llega la noche parece que se olvidan!!!')
                ],
                :tags           => %w(seguridad ciudadania robos).join(',')

create_question :text     => 'Desde el barrio de Pradoalto, rogamos que se tenga en cuenta nuestra situación y pongan una linea de autobus a nuestro barrio.',
                :areas    => [@area],
                :users    => [@patricia],
                :for      => @javier,
                :tags     => %w(transporte Pradoalto movilidad).join(','),
                :answer => {
                  :text => 'Estamos hablando ya con varias empresas locales de transporte para buscar una solución que nos beneficie a los vecinos de Pradoalto. Se baraja la posibilidad de poner una linea de autobus para estudiantes de enseñanza primaria y secundaria en horario lectivo.',
                  :author => @aitana,
                  :areas => [@area],
                  :comments => [
                    create_comment(@andres, 'nos podrían regalar bicis!!!'),
                    create_comment(@iker, 'no se si será porque somos un barrio nuevo o porqué, pero también pagamos nuestros impuestos como la gente de otros barrios'),
                    create_comment(@gonzalo, 'chicos, me han dicho que en breve tendremos ya una ruta que pasará por nuestras calles. Yuhuuuu!!')
                  ]
                }

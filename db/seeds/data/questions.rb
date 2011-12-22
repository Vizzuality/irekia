#encoding: UTF-8

puts ''
puts 'Creating questions...'
puts '====================='

create_question :text           => '¿Podría decirme cuando tienen pensado finalizar las obras de la calle Libertad?',
                :author         => @andres,
                :for            => @aitana,
                :comments       => [
                  create_comment(@alejandro, 'Dijeron que en principio eran unos meses, y ya van camino del año... Esperemos no dure mucho mas, porque tengo que aparcar lejos y cuando me toca venir con la compra no me hace mucha gracia la verdad'),
                  create_comment(@iker, 'Seguro que a los pocos meses la vuelven a abrir para cambiar o poner otras cosas...')
                ],
                :tags           => %w(trafico obra ciudadanía).join(','),
                :answer         => {
                  :text     => (<<-EOF
                    Hola Andrés,

                    En el plazo máximo de 4 meses, la empresa constructora nos confirmo que estaría abierta la calle de nuevo al trafico. Las obras las estamos realizando como mejora del sistema de canalización de agua. Rogamos disculpen los problemas ocasionados tanto a viandantes como vecinos de la zona.
                    Estamos trabajando para la mejora de nuestra ciudad.
                  EOF
                  ),
                  :author   => @aitana,
                  :comments => [
                    create_comment(@alejandro, 'La verdad que se hace cansado el constante ruido al que estamos expuestos. Además del polvo y la suciedad que llevamos sufriendo tantos meses.'),
                    create_comment(@gonzalo, 'Quedará todo genial despues de tantos meses...')
                  ]
                }



create_question :text     => '¿Por qué es tan dificil jugar al padel en Vizcaya? Llevo varias semanas intentando reservar pista y siempre me encuentro con que está reservada.',
                :author   => @gonzalo,
                :for      => @aitor,
                :comments => [
                  create_comment(@patricia, 'Me gustaría saber si por internet y por telefono se puede reservar o solamente es presencial.  Es dificil jugar al padel, esperemos pongan soluciones pronto.'),
                  create_comment(@andres, 'Yo me canso mas intentando reservar pista que luego jugando!!')
                ],
                :tags           => %w(deporte padel polideportivo).join(','),
                :answer         => {
                  :text => (<<-EOF
                  Hola,
                  Somos conscientes del creciente aumento del padel en nuestra ciudad. Ya hemos recibido varias quejas y estamos barajando la posibilidad de construir pistas en las afueras de la ciudad con el fin de que todos podamos disfrutar de la practica de padel.

                  Gracias por hacernos llegar vuestras sugerencias.
                  EOF
                  ),
                  :author => @javier,
                  :comments => [
                    create_comment(@iker, 'Además de poner mas pistas tambien sería un detalle por vuestra parte bajar los precios, porque son algo excesivos la verdad! Seria una forma bastante interesante de fomentar mas el deporte')
                  ]
                }

create_question :text     => 'Llevamos varios meses ya de inseguridad ciudadana y varias decenas de denuncias,  ¿hasta cuando vamos a tener que aguantar la inseguridad que hay en nuestras calles?',
                :author   => @iker,
                :for      => Area.find(3),
                :want_an_answer => [@patricia],
                :comments => [
                  create_comment(@gonzalo, 'Conozco a varios vecinos que han sufrido amenazas y robos. Al final acabaremos realizando patrullas callejeras, en plan americano.'),
                  create_comment(@patricia, 'La verdad que las calles se están volviendo territorio hostil. Esperemos que nuestras quejas no caigan en saco roto y nos hagan caso. Estoy bastante preocupada por mis hijos'),
                  create_comment(@andres, 'A mi me da miedo salir de noche por la calle. durante el dia pasan algunos coches de policiía pero cuando llega la noche parece que se olvidan!!!')
                ],
                :tags           => %w(seguridad ciudadania robos).join(',')

create_question :text     => 'Desde el barrio de Pradoalto, rogamos que se tenga en cuenta nuestra situación y pongan una linea de autobus a nuestro barrio.',
                :author   => @patricia,
                :for      => @javier,
                :tags     => %w(transporte Pradoalto movilidad).join(','),
                :answer => {
                  :text => 'Hola,

                  Estamos hablando ya con varias empresas locales de transporte para buscar una solución que nos beneficie a los vecinos de Pradoalto. Se baraja la posibilidad de poner una linea de autobus para estudiantes de enseñanza primaria y secundaria en horario lectivo.

                  Gracias a todos por vuestro interés en mejorar el País Vasco.',
                  :author => @aitana,
                  :comments => [
                    create_comment(@andres, 'Nos podrían regalar bicis!!!'),
                    create_comment(@iker, 'No se si será porque somos un barrio nuevo o porqué, pero también pagamos nuestros impuestos como la gente de otros barrios'),
                    create_comment(@gonzalo, 'Chicos, me han dicho que en breve tendremos ya una ruta que pasará por nuestras calles. Yuhuuuu!!')
                  ]
                }

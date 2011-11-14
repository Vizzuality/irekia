#encoding: UTF-8

puts ''.green
puts 'Creating news...'.green
puts '================'.green

create_news :title        => 'San Sebastián es elegida capital europea de la cultura en 2016',
            :subtitle     => 'La candidatura donostiarra se ha impuesto frente a las de Córdoba, Burgos, Las Palmas, Segovia y Zaragoza. Esta decisión llena de satisfación a todas las personas que han luchado por este proyecto.',
            :body         => (<<-EOF
              San Sebastián ha sido elegida Capital Europea de la Cultura 2016 junto a la ciudad polaca de Wroclaw. San Sebastián se impone así sobre la que sonaba como favorita, Córdoba, y a otras cuatro candidatas: Burgos, Segovia, Las Palmas y Zaragoza. San Sebastián afronta esta designación en un contexto de incertidumbre política por el reciente cambio en el equipo de Gobierno municipal, que ha pasado a manos de Bildu.

              En los actos finales de presentación del proyecto de la capital guipuzocana han participado conjuntamente el exalcalde socialista, Odón Elorza, y el nuevo alcalde, Juan Karlos Izagirre. "Zorionak Donostia. Zorionak Euskadi entre todos lo hemos conseguido", ha señalado el lehendakari Patxi López a través de su perfil en la red social Twitter.
            EOF
            ),
            :image        => File.open(Rails.root.join('db/seeds/support/images/news_1.jpg')),
            :tags         => %w(capital\ europea cultura san\ sebastian).join(','),
            :author       => @aitana,
            :users_tagged => User.politicians.sample((1..5).to_a.sample),
            :comments     => [
                      create_comment(@andres, 'Una buena noticia para los vascos! Esperemos que gse creen puestos de trabajo, aunque sean temporales!'),
                      create_comment(@gonzalo, 'Una excusa más para visitar Euskadi y también Wroclaw! Ahora a ponerse a trabajar para que sea un exito (eso va por nuestros políticos...'),
                      create_comment(@patricia, 'Me enteré tarde de la noticia, pero me alegré mucho!!! Conozco a gente que ha trabajado en el diseño del logo y me hace mucha ilusión verlo en periodicos y paginas web')
                    ]

#######################################

create_news :title        => 'La Behobia-SS abandona el calendario de la Española',
            :subtitle     => 'La organización rechaza la norma federativa que impone el pago de un canon de tres euros por atleta. Debido a esta circunstancia, atletasde elite como Chema Martínez o Rafa Iglesias no estarán en la salida.',
            :body         => (<<-EOF
                          La Behobia-San Sebastián, que se disputa el domingo 13, abandona el calendario de la Federación Española renunciando así a la presencia de atletas de elite
La popularísima prueba pedestre de la Behobia-San Sebastián se sale del calendario nacional establecido por la Real Federación Española de Atletismo por su desacuerdo y disconformidad con el reglamento que obliga a los organizadores a pagar un canon de tres euros por atleta participante.

De esta manera, la Behobia no podrá contar con atletas becados por el ente federativo ya que estos no pueden disputar carreras que no estén en el programa oficial de competición.
La consecuencia más directa de esta decisión del fortuna repercute a dos atletas profesionales asiduos a este circuito guipuzcoano, el madrileño Chema Martínez –cuatro veces ganador– y el salmantino Rafa Iglesias, vencedor de las dos últimas ediciones.
            EOF
            ),
            :image        => File.open(Rails.root.join('db/seeds/support/images/news_2.jpg')),
            :tags         => %w(behobia carrera san\ sebastian).join(','),
            :author       => @javier,
            :users_tagged => User.politicians.sample((1..5).to_a.sample),
            :comments     => [
              create_comment(@gonzalo, 'Lamentable las decisiones que se toman. Vaya forma de fomentar el deporte. Asi vamos bastante mal!!!'),
              create_comment(@iker, 'Me pareceEstá bien que el fortuna no quiera aportar nada a la RFEA. En cuanto al precio de inscripción lo pone el club y puede participar quien quiera. Hay un ejemplo similar de una carrera muy popular en bizkaia como es la herri krossa y su precio es de 5 euros. Lo peor de todo es que bien Gobierno Vasco, Diputación y Ayuntamiento les den subvenciones.'),
              create_comment(@andres, 'No defiendo los precios todo lo contrario,pero si que es cierto que fortuna destina parte del dinero a todas las secciones de deportes que practica y que son muchas...')
            ]


#######################################

create_news :title        => 'La Fundación Bilbao 700 inicia este jueves una nueva edición del ciclo de música barroca en el teatro Campos',
            :subtitle     => "El ciclo 'Bilbao Estación Barroca', organizado por la Fundación Bilbao 700-III Millenium en colaboración con Arteria Campos Elíseos, iniciará este jueves una nueva temporada de conciertos, que se prolongará hasta el día 25 de noviembre.",
            :body         => (<<-EOF
El ciclo 'Bilbao Estación Barroca', organizado por la Fundación Bilbao 700-III Millenium en colaboración con Arteria Campos Elíseos, iniciará este jueves una nueva temporada de conciertos, que se prolongará hasta el día 25 de noviembre y ofrecerá "cuatro producciones a cargo de destacadas formaciones y solistas que, en los últimos años, han actualizado este estilo musical con un enfoque original y novedoso".

El programa cuenta con la participación de las orquestas barrocas Le Poème Armonique (15 músicos), Les Folies Françoises (24 músicos) y La Grande Chapelle (20 músicos) dirigidas por Vincent Dumestre, Patrick Cohën-Akenine y Albert Recasens, respectivamente.

Junto a solistas de "primer nivel", estas formaciones interpretarán algunas de las obras de los grandes compositores del barroco italiano, francés y español, según han explicado sus organizadores.
            EOF
            ),
            :image        => File.open(Rails.root.join('db/seeds/support/images/news_3.jpg')),
            :tags         => %w(teatro cultura musica evento).join(','),
            :author       => @aitor,
            :areas_tagged => [@area],
            :users_tagged => User.politicians.sample((1..5).to_a.sample),
            :comments     => [
              create_comment(@iker, 'El año pasado estuve y me pareció muy bueno! Este año volveré!'),
              create_comment(@alejandro, 'Se echa de menos la ausencia de artistas españoles, pero bueno. Lo mejor sigue siendo el precio!!'),
              create_comment(@patricia, 'Alguien sabe si se podrian comprar por internet? Si es posible, decirme cual es el link, porque estoy fuera y me es mas como no tener que ir hasta alli solo por las entradas.')
            ]


#######################################

create_news :title        => 'Sumilleres del País Vasco abren este jueves, día 3, en Bilbao la XXI Nariz de Oro',
            :subtitle     => 'Los mejores sumilleres de País Vasco, junto a sumilleres llegados desde Navarra, Cantabria y La Rioja, se reunirán este jueves en el Hotel Silken Gran Domine Bilbao para intentar conseguir una plaza en la final de la competición.',
            :body         => (<<-EOF
Los mejores sumilleres de País Vasco, junto a sumilleres llegados desde Navarra, Cantabria y La Rioja, se reunirán este jueves en el Hotel Silken Gran Domine Bilbao para intentar conseguir una plaza en la final de la competición.

Según han informado los organizadores, junto a la competición de sumilleres, se celebrará la Nariz de Oro Experimenta, un espacio gastronómico abierto al público en el que los asistentes podrán aprender a crear tapas, cócteles e incluso a manejar el arte de cortar jamón.

La cita será la primera semifinal de la competición y tras ella, la Nariz de Oro viajará a Santiago, Valencia, Barcelona, Madrid y Málaga en busca de los sumilleres que representarán a sus respectivas zonas en la final.
            EOF
            ),
            :image        => File.open(Rails.root.join('db/seeds/support/images/news_4.jpg')),
            :tags         => %w(vino sumiller evento concurso).join(','),
            :author       => @aitor,
            :users_tagged => User.politicians.sample((1..5).to_a.sample),
            :comments     => [
              create_comment(@gonzalo, 'Alguien me podría informar si la entrada es gratuita o hay que sacar entrada? Hay que tener invitacion previa?'),
              create_comment(@patricia, 'No, es totalmente gratis. Además allí hay degustaciones y demostraciones.'),
              create_comment(@andres, 'En este tipo de eventos uno puede probar caldos que en circunstancias normales no le es posible. Siempre que puedo asisto a dichas citas!!')
            ]


#######################################

create_news :title        => 'El Gobierno Vasco aprueba los Presupuestos generales para 2010.',
            :subtitle     => 'El IVA sube de esta forma. El Consejo de Ministros extraordinario elimina la ayuda de 400 €. Los Presupuestos serán sometidos a votación en el Congreso el martes. El Gobierno tiene ahora que negociar con los grupos parlamentarios.',
            :body         => (<<-EOF
Controvertidos y delicados. Los Presupuestos para el 2010 -los sextos de la era Zapatero- han sido aprobados por el Gobierno en Consejo de Ministros extraordinario -provocado por el viaje a la Asamblea General de la ONU del presidente del Ejecutivo y de la vicepresidenta segunda, Elena Salgado- celebrado este sábado en Madrid. La vicepresidenta Fernández De la Vega ha calificado las nuevas cuentas generales de "realistas", "solidarias" y "equitativas"

La vicepresidenta Primera del Gobierno, María Teresa Fernández de la Vega, ha sido la primera en intervenir en rueda de prensa. De la Vega ha dicho que los Presupuestos para el próximo año son "austeros" debido a la "difícil coyuntura económica".

Son "Presupuestos" para "la reactivación de una economía sostenible y la reactivación del empleo".
            EOF
            ),
            :image        => File.open(Rails.root.join('db/seeds/support/images/news_5.jpg')),
            :tags         => %w(presupuestos politica economía 2010).join(','),
            :author       => @aitana,
            :users_tagged => User.politicians.sample((1..5).to_a.sample),
            :comments     => [
              create_comment(@iker, 'O sea, a comer huevos, tostadas de pan con pan y un vasito de leche. Iremos andando a trabajar (si tenemos trabajo, claro). Y a las 20 h. a dormir que las velas se nos acabarán.. (creo que tienen el iva reducido...) y creo que la electricidad no esta gravada con un 4%.'),
              create_comment(@alejandro, 'Eso de que el iva de los productos de primera necesidad no subira no es mas que un cuento chino, el producto subira por que los costes de produccion y transporte se incrementaran con la subida del IVA ¿o es que nos van a decir que el pienso para dar de comer a las gallinas que ponen huevos no le van a aplicar la subida de IVA? o al agricultor en el Agua, fertilizantes y demas??')
            ]


#encoding: UTF-8

puts ''.green
puts 'Creating proposals...'.green
puts '====================='.green

create_proposal :title    => 'Calidad del aire en Euskadi',
                :body     => (<<-EOF
                      Estos días estamos a vueltas con la contaminación presente en Madrid que hasta ha salido en la foto de campaña del PP. Dicen que los medidores de la red de Madrid han pasado los límites permitidos por la UE. En Euskadi contamos con una red también, en la que nos cuentan las bondades del aire vasco. Una red, cuya pagina web a parte de una actualización deficiente, te da sorpresas como la que aparece en la foto en la que el día 18 de octubre en Euskadi no tenemos nada que envidiar al aire de Madrid.
Propongo que ya que desde esta plataforma se intenta dar voz al ciudadano y que desde el gobierno se intenta dar una imagen de transparencia, esta página web se actualice día a día y no en días alternos.
Y de paso, como he leído en otra propuesta, si no se va a actualizar la previsión, mejor quitarla.
Supongo que lo de la foto será un fallo, pero no da un buen ejemplo de profesionalidad.
                EOF
                ),
                :target   => Area.first,
                :tags     => %w(contaminación ecología Medio\ Ambiente).join(','),
                :area     => @area,
                :author   => @andres,
                :comments => [
                  create_comment(@andres, 'hoy dia poca gente se preocupa por la calidad del aire. Damos por hecho que hay contaminación y ya está y no nos damos cuenta que estamos respirando un aire que no es muy bueno para nuestra salud. Si pusieramos de nuestra parte y el gobierno de la suya pondriamos remedio para tener un mejor aire en nuestras ciudades.' ),
                  create_comment(@patricia, 'estoy totalmente de acuerdo. Si la gente se concienciara mas y tuviera una mentalidad algo mas ecológica podriamos respirar un aire bastante mas limpio... Lo cual nos beneficiaría a todos!')
                ]

create_proposal :title    => 'Plantación de árboles autóctonos',
                :body     => (<<-EOF
Según un estudio de Neiker-Tecnalia "Los bosques vascos tienen capacidad para absorber el doble de carbono". Los montes del País Vasco registran valores bajos de carbono, entre el 22 % y el 40 % de su potencial, y se sitúan lejos de su capacidad de captación.
Los bajos niveles de acumulación podrían deberse, según la investigación, a las antiguas políticas forestales y al abusivo aprovechamiento de leña, carbón, mantillo y arbustos.
Se propone aumentar la superficie del bosque vasco con la plantación de árboles autóctonos para fijar el carbono, abrir corredores ecológicos, mejorar el estado de los nuestros ecosistemas naturales, la calidad de nuestro aire y generando puestos de trabajo verdes.
                EOF
                ),
                :target   => Area.first,
                :tags     => %w(arboles naturaleza Medio\ Ambiente).join(','),
                :area     => @area,
                :author   => @gonzalo,
                :comments => [
                  create_comment(@iker, 'en el País Vasco tenemos unos prados extraordinarios! Aunque deberíamos repoblar mas, porque en otros tiempos teníamos unos bosques mas chulos!!'),
                  create_comment(@andres, 'debemos cambiar las actuales políticas por unas mas ecologistas. Antiguamente se ctalaban arboles a diestro y siniestro y nunca nos preocupamos de repoblar.')
                ]

create_proposal :title    => 'Competencias policiales durante la noche',
                :body     => (<<-EOF
Hola:
En Euskadi hay poblaciones como Ondarroa (10000 habitantes más o menos) en las cuales durante la noche, desde las 22:00 hasta las 06:00 horas, no hay servicio de policía municipal. Yo creía que en este caso, era la Ertzantza la que asumía dichas competencias; pero resulta que he llamado varias veces por problemas de ruidos y horarios de cierre de un establecimiento hostelero que tenemos en un bajo de mi domicilio y las respuestas han sido variadas y diversas: desde venir y levantar un acta de horarios y ruidos, hasta " no es competencia nuestra sino municipal. Ya llamaremos pero no te prometemos nada..". Me gustaría ( que yo creo que es así) que en caso de ausencia de servicio de policía municipal, la ERTZANTZA asuma dichas competencias. Y por supuesto, que lo tengan claro en todas las comisarías y hagan cumplir el DECRETO 140/1997, de 17 de junio.
Gracias
                EOF
                ),
                :target   => Area.first,
                :tags     => %w(policia seguridad ciudadanía).join(','),
                :area     => @area,
                :author   => @patricia,
                :comments => [
                  create_comment(@patricia, 'ya de por si algunas veces da miedo salir por la noche a la calle, pero sabiendo que no disponemos de policia muchisimo mas!!! Tienen pensado poner solución o directamente solo podremos salir por la noche a bajar la basura?'),
                  create_comment(@alejandro, 'deberíamos recoger firmas y movilizarnos  para poder tener una seguridad ciudadana digna!')
                ]


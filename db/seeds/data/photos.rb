#encoding: UTF-8

puts ''.green
puts 'Creating photos...'.green
puts '=================='.green

photos_texts = [
{
  :title => 'Lleno completo en el auditorio.',
  :description => 'Da gusto venir al auditorio nacional y encontrarse con este público. Ojalá se ponga así con todos los conciertos de música clasica!.'
},
{
  :title => 'El festival va a empezar.',
  :description => 'Todo listo y preparado para la noche de la alfombra roja! Ahora a arreglarse todo el mundo!'
},
{
  :title => 'Patxi y Antonio',
  :description => 'Da gusto ver como el lehendakari charla y escucha a todo aquel que lo necesita.'
},
{
  :title => 'Probando la nueva versión de twitter.',
  :description => 'Parece que le gusta, esta enganchado!'
},
{
  :title => 'Comilona en el hotel Santa Maria',
  :description => 'Buen lugar para comenzar un lunes de campaña electoral. Un buen menú por 12euros.'
},
{
  :title => 'Patxi lopez en Pekín.',
  :description => 'Vemos como los anfitriones reciben al lehendakari y el txakoli con los brazos abiertos :).'
},
{
  :title => 'Vamos equipo!',
  :description => 'Menudo equipazo se ha juntado en este viaje a EEUU. Seguro que será un viaje muy productivo.'
},
{
  :title => 'Lleno completo en el auditorio.',
  :description => 'Da gusto venir al auditorio nacional y encontrarse con este público. Ojalá se ponga así con todos los conciertos de música clasica!.'
},
{
  :title => 'Biblioteca del colegio Ramiro de Maeztu.',
  :description => 'Como ven los alumnos de este colegio son de los que les gusta leer. Han ganado el premio nacional de literatura para menores en el concuros nacional!'
},
{
  :title => 'Pintxos en Bilbao',
  :description => 'Tras la rueda de prensa de hoy, hay que reponer fuerzas. Destaco el pintxo de huevo con trufa, eh!'
},
{
  :title => 'Entre aplausos',
  :description => 'Gran intervención de la Virginia Uriarte en el congreso de participación cuidadana celebrado hoy en Bilbao, que acabo entre aplausos.'
},
{
  :title => 'Patxi lopez en San Sebastián.',
  :description => 'Empieza la campaña y la primera cita es San Sebastián. Lleno absoluto hoy.'
},
{
  :title => 'Reunión de preparación.',
  :description => 'Menudo equipazo se ha juntado en este viaje a EEUU. Seguro que será un viaje muy productivo.'
},
{
  :title => 'Pintxos en Zarautz.',
  :description => 'Tras la rueda de prensa de hoy, hay que reponer fuerzas. Destaco el pintxo de huevo con trufa, eh!'
}
]

(0..13).to_a.each do |i|
  create_photo :title => photos_texts[i][:title],
               :description => photos_texts[i][:description],
               :image => File.open(Rails.root.join(%Q{db/seeds/support/images/photo_#{"%02d" % i}.jpg})),
               :tags => %w(Comisión Transporte Gobierno\ Vasco Transporte).join(','),
               :author => User.politicians.sample,
               :comments => [
                  create_comment(User.citizens.sample, <<-EOF
                    Me encantaría que realmente esta gente fuera siempre a los eventos y nos lo comunicaran como en esta ocasión. La verdad que fue un buen momento para hablar con ellos y conocerlos en persona.
                  EOF
                  ),
                  create_comment(User.citizens.sample, <<-EOF
                    Yo estuve allí y la verdad es que no fue gran cosa...
                  EOF
                  )
               ]

end

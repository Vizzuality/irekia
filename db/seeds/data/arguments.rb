#encoding: UTF-8

puts ''
puts 'Creating arguments...'
puts '====================='

create_argument :author => User.all.sample,
                :proposal => @proposal1,
                :reason => 'Me encanta esta iniciativa! Aunque no soluciona nada nos ayudar a ser mas conscientes del aire que respiramos',
                :in_favor => true

create_argument :author => User.all.sample,
                :proposal => @proposal1,
                :reason => 'Si en todas las ciudades de España tuviéramos el conocimiento del aire que respiramos a lo mejor iríamos mas en transporte público',
                :in_favor => true

create_argument :author => User.all.sample,
                :proposal => @proposal1,
                :reason => 'Me parece un poco absurda. Está bien conocer la calidad del aire pero sería más efectivo ir en transporte público y dejarnos de tanto coche!',
                :in_favor => false

create_argument :author => User.all.sample,
                :proposal => @proposal2,
                :reason => 'Me parece una idea muy buena. Menos mal que alguien se preocupa por repoblar los bosques y que no se quede en meras intenciones.',
                :in_favor => true

create_argument :author => User.all.sample,
                :proposal => @proposal2,
                :reason => 'Estoy totalmente de acuerdo con estas iniciativas. Es todo un ejemplo a seguir y esperemos tomen nota el resto de  organismos autónomos y así recuperar los bosques españoles.',
                :in_favor => true

create_argument :author => User.all.sample,
                :proposal => @proposal2,
                :reason => 'Es absurdo preocuparnos de los bosques con la que nos está cayendo actualmente. Deberíamos centrarnos mas en cosas como la vivienda y el paro que en repoblar bosques!!!',
                :in_favor => false

create_argument :author => User.all.sample,
                :proposal => @proposal3,
                :reason => 'Todo lo que sea mejorar la calidad de vida y sobre todo la seguridad , pues mucho mejor. Tener una seguridad en el barrio nos tranquiliza, y mas si tenemos hijos.',
                :in_favor => true

create_argument :author => User.all.sample,
                :proposal => @proposal3,
                :reason => 'A ver si de una vez por todas se acuerdan de que existimos!!!',
                :in_favor => true

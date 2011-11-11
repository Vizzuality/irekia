#encoding: UTF-8

puts ''.green
puts 'Creating users...'.green
puts '================='.green

@admin = create_user :name                  => 'Administrator',
                     :lastname              => 'Administrator',
                     :email                 => 'admin@example.com',
                     :password              => 'example',
                     :password_confirmation => 'example',
                     :inactive              => false,
                     :title                 => nil,
                     :role                  => Role.find_by_name('Administrator')

#############
# Politicians
#############

@aitana = create_user :name                  => 'Aitana',
                      :lastname              => 'Muguruza Odriozola',
                      :email                 => 'aitana_muguzola@yahoo.es',
                      :is_woman              => true,
                      :description           => (<<-EOF
                        Aitana es la persona encargada de Deportes del Gobierno Vasco.
                        Coordina y gestiona tanto infraestructuras deportivas como eventos.
                        Actualmente inmersa en el desarrollo del deporte escolar y de barrio.
                      EOF
                      ),
                      :title                 => Title.find_by_name('Adviser'),
                      :role                  => Role.find_by_name('Politician'),
                      :area_user             => AreaUser.create(:area  => @area, :display_order => 1),
                      :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'politico_00.jpg')))

@aitor = create_user :name                  => 'Aitor',
                     :lastname              => 'García Ibarra',
                     :email                 => 'aitor_garcia_ibarra@hotmail.com',
                     :is_woman              => false,
                     :description           => (<<-EOF
                       Aitor dirige y tramita la Sanidad del Gobierno Vasco.
                       Entre sus principales funciones destaca velar por el desarrollo del sistema sanitario y reducir tanto listas de espera como los tiempos de atención a pacientes.
                     EOF
                     ),
                     :role                  => Role.find_by_name('Politician'),
                     :area_user             => AreaUser.create(:area  => @area, :display_order => 2),
                     :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'politico_01.jpg')))

@javier = create_user :name                  => 'Javier',
                      :lastname              => 'Jimenez Alvarez',
                      :email                 => 'jamal@gmail.com',
                      :is_woman              => false,
                      :description           => (<<-EOF
                        Javier actualmente trabaja  en el Departamento de Educación.
                        Dirigir los organismos autónomicos, entes públicos de derecho privado y sociedades públicas adscritos al Departamento.
                      EOF
                      ),
                      :role                  => Role.find_by_name('Politician'),
                      :area_user             => AreaUser.create(:area  => @area, :display_order => 2),
                      :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'politico_02.jpg')))

@ainara = create_user :name                  => 'Ainara',
                      :lastname              => 'Sanchéz Urkullu',
                      :email                 => 'asanch@hotmail.com',
                      :is_woman              => true,
                      :description           => (<<-EOF
                        Ainara trabaja actualmente en el área de Medio Ambiente del Gobierno Vasco.
                        Desarrolla y fomenta diversos programas de protección del Medio Ambiente, así como multitud de actividades relacionadas con el mismo.
                      EOF
                      ),
                      :role                  => Role.find_by_name('Politician'),
                      :area_user             => AreaUser.create(:area  => @area),
                      :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'politico_03.jpg')))

@joel = create_user :name                  => 'Joel',
                    :lastname              => 'López Leiva',
                    :email                 => 'jlopez_leiva@gmail.com',
                    :is_woman              => false,
                    :description           => (<<-EOF
                      Joel promueve y desarrolla el Departamento de Asuntos Sociales.
                      Busca una constante solución a los problemas cotidianos de los ciudadanos vascos, eliminando barreras e impedimentos para permitir un mejor nivel de vida.
                    EOF
                    ),
                    :role                  => Role.find_by_name('Politician'),
                    :area_user             => AreaUser.create(:area  => @area, :display_order => 2),
                    :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'politico_04.jpg')))

#############
# Citizens
#############

@andres = create_user :name                  => 'Andrés',
                      :lastname              => 'Medina Jiménez',
                      :email                 => 'andresmedina@hotmail.com',
                      :title                 => nil,
                      :is_woman              => false,
                      :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'usuario_00.jpg'))),
                      :users_following       => User.politicians,
                      :areas_following       => Area.all

@gonzalo = create_user :name                  => 'Gonzalo',
                       :lastname              => 'Aranburu Corrales',
                       :email                 => 'corraburu@gmail.com',
                       :title                 => nil,
                       :is_woman              => false,
                       :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'usuario_01.jpg'))),
                       :users_following       => User.politicians,
                       :areas_following       => Area.all

@patricia = create_user :name                  => 'Patricia',
                        :lastname              => 'Gómez Pecero',
                        :email                 => 'pagocero@hotmail.com',
                        :title                 => nil,
                        :is_woman              => true,
                        :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'usuario_02.jpg'))),
                        :users_following       => User.politicians,
                        :areas_following       => Area.all

@alejandro = create_user :name                  => 'Alejandro',
                         :lastname              => 'Bengoechea Ramirez',
                         :email                 => 'alejandro_bengoechea@yahoo.com',
                         :title                 => nil,
                         :is_woman              => false,
                         :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'usuario_03.jpg'))),
                         :users_following       => User.politicians,
                         :areas_following       => Area.all

@iker = create_user :name                  => 'Iker',
                    :lastname              => 'Urieta Mendía',
                    :email                 => 'urieta1981@msn.com',
                    :title                 => nil,
                    :is_woman              => false,
                    :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'usuario_04.jpg'))),
                    :users_following       => User.politicians,
                    :areas_following       => Area.all

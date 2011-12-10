#encoding: UTF-8

puts ''
puts 'Creating users...'
puts '================='

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
                      :description_1         => (<<-EOF
                        Aitana es la persona encargada de Deportes del Gobierno Vasco y una de las personas mas jóvenes del equipo de gobierno. Coordina y gestiona tanto infraestructuras deportivas como eventos. Actualmente centra la mayor parte de sus
                      EOF
                      ),
                      :description_2         => (<<-EOF
                        esfuerzos en desarrollar el deporte escolar y de barrio.
                      EOF
                      ),
                      :title                 => Title.find_by_name('Adviser'),
                      :role                  => Role.find_by_name('Politician'),
                      :area_user             => AreaUser.create(:area  => Area.find(7), :display_order => 1),
                      :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'politico_00.jpg')))

@aitor = create_user :name                  => 'Aitor',
                     :lastname              => 'García Ibarra',
                     :email                 => 'dcano@vizzuality.com',
                     :is_woman              => false,
                     :description_1         => (<<-EOF
                       Aitor dirige y tramita la Sanidad del Gobierno Vasco. Entre sus principales funciones destaca velar por el desarrollo del sistema sanitario y reducir tanto listas de espera como los tiempos de atención a pacientes, además de construir un hospital con las últimas tecnologías para la
                     EOF
                     ),
                     :description_2         => (<<-EOF
                     atención de pacientes y la investigación en cada área del País Vasco.
                      EOF
                      ),
                     :role                  => Role.find_by_name('Politician'),
                     :area_user             => AreaUser.create(:area  => Area.find(7), :display_order => 2),
                     :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'politico_01.jpg')))

@javier = create_user :name                  => 'Javier',
                      :lastname              => 'Jimenez Alvarez',
                      :email                 => 'saleiva@vizzuality.com',
                      :is_woman              => false,
                      :description_1         => (<<-EOF
                        Javier actualmente trabaja en el Departamento de Educación. Su día a día se desarrolla dirigiendo los organismos autónomicos, entes públicos de derecho privado y sociedades públicas adscritos al Departamento encargadas de todos los
                      EOF
                      ),
                      :description_2         => (<<-EOF
                        ámbitos que rodéan a la investigación, el desarrollo y la educación pública.
                      EOF
                      ),
                      :role                  => Role.find_by_name('Politician'),
                      :area_user             => AreaUser.create(:area  => Area.find(7), :display_order => 2),
                      :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'politico_02.jpg')))

@ainara = create_user :name                  => 'Ainara',
                      :lastname              => 'Sanchéz Urkullu',
                      :email                 => 'asanch@hotmail.com',
                      :is_woman              => true,
                      :description_1         => (<<-EOF
                        Ainara trabaja actualmente en el área de Medio Ambiente del Gobierno Vasco. Amante de los animales y los paisajes desconocidos, desarrolla y fomenta diversos programas de protección del Medio Ambiente, así como multitud de actividades relacionadas con el mismo.
                      EOF
                      ),
                      :description_2         => (<<-EOF
                        Ella afirma que no podría imaginarse viviendo en un mejor lugar el País Vasco.
                      EOF
                      ),
                      :role                  => Role.find_by_name('Politician'),
                      :area_user             => AreaUser.create(:area  => Area.find(7)),
                      :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'politico_03.jpg')))

@joel = create_user :name                  => 'Joel',
                    :lastname              => 'López Leiva',
                    :email                 => 'jlopez_leiva@gmail.com',
                    :is_woman              => false,
                    :description_1         => (<<-EOF
                      Joel promueve y desarrolla el Departamento de Asuntos Sociales. Busca una constante solución a los problemas cotidianos de los ciudadanos vascos, eliminando barreras e impedimentos para permitir un mejor nivel de vida. Muchos de
                    EOF
                    ),
                    :description_2         => (<<-EOF
                      sus compañeros aseguran que apenas duerme, trabaja todo el día.
                    EOF
                    ),
                    :role                  => Role.find_by_name('Politician'),
                    :area_user             => AreaUser.create(:area  => Area.find(7), :display_order => 2),
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
                      :users_following       => [@aitana]

@patricia = create_user :name                  => 'Patricia',
                        :lastname              => 'Gómez Pecero',
                        :email                 => 'pagocero@hotmail.com',
                        :title                 => nil,
                        :is_woman              => true,
                        :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'usuario_01.jpg'))),
                        :users_following       => [@aitor],
                        :areas_following       => Area.all

@gonzalo = create_user :name                  => 'Gonzalo',
                       :lastname              => 'Aranburu Corrales',
                       :email                 => 'corraburu@gmail.com',
                       :title                 => nil,
                       :is_woman              => false,
                       :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'usuario_02.jpg'))),
                       :users_following       => [@javier]

@alejandro = create_user :name                  => 'Alejandro',
                         :lastname              => 'Bengoechea Ramirez',
                         :email                 => 'alejandro_bengoechea@yahoo.com',
                         :title                 => nil,
                         :is_woman              => false,
                         :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'usuario_03.jpg'))),
                         :users_following       => [@ainara]

@iker = create_user :name                  => 'Iker',
                    :lastname              => 'Urieta Mendía',
                    :email                 => 'urieta1981@msn.com',
                    :title                 => nil,
                    :is_woman              => false,
                    :profile_picture       => Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', 'usuario_04.jpg'))),
                    :users_following       => [@joel]

#encoding: UTF-8

# Areas
Area.create :name => 'Lehendakaritza',
            :description => 'Dirige, impulsa y coordina la acción del Gobierno Vasco y establece las directrices de la política. Designa y separa libremente al Vicepresidente y Consejeros. Detenta el rango de titular de Departamento respecto de las funciones, órganos y unidades que tiene asignados. Esta sección le permitirá conocer la institución: su historia y su funcionamiento.',
            :description_1 => 'Dirige, impulsa y coordina la acción del Gobierno Vasco y establece las directrices de la política. Designa y separa libremente al Vicepresidente y Consejeros. Detenta el rango de titular de Departamento respecto de las funciones, órganos y unidades que tiene asignados. Esta sección le',
            :description_2 => 'permitirá conocer la institución: su historia y su funcionamiento.',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_01.png'))),
            :external_id => 1

Area.create :name => 'Interior',
            :description => 'La preparación y ejecución de la política del Gobierno en relación con la administración general de la seguridad ciudadana. La promoción de las condiciones para el ejercicio de los derechos fundamentales, especialmente en relación con la libertad y seguridad personal, en los términos establecidos en la Constitución Española y en las leyes que los desarrollen.',
            :description_1 => 'La preparación y ejecución de la política del Gobierno en relación con la administración general de la seguridad ciudadana. La promoción de las condiciones para el ejercicio de los derechos fundamentales, especialmente en relación con la libertad y seguridad',
            :description_2 => 'personal, en los términos establecidos en la Constitución Española y en las leyes que los desarrollen.',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_02.png'))),
            :external_id => 2

Area.create :name => 'Economía y Hacienda',
            :description => 'Es el departamento ministerial del gobierno vasco encargado de la gestión de sus asuntos económicos y de Hacienda pública. Aquí encontrará datos e indicadores de la economía del País Vasco, así como enlaces a informaciones sobre finanzas, hacienda y fondos de cohesión y estructurales.',
            :description_1 => 'Es el departamento ministerial del gobierno vasco encargado de la gestión de sus asuntos económicos y de Hacienda pública. Aquí encontrará datos e indicadores de la economía del País Vasco, así como enlaces a informaciones',
            :description_2 => 'sobre finanzas, hacienda y fondos de cohesión y estructurales.',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_03.png'))),
            :external_id => 3

Area.create :name => 'Educación, Universidades e Investigación',
            :description => 'En este apartado puede consultar información sobre estudios, centros, becas y otros servicios relacionados con esta materia y su regulación. Además  de Calidad e Innovación educativa, centros y servicios educativos disponibles, formación especializada y las becas y ayudas así como otros muchos apartados.',
            :description_1 => 'En este apartado puede consultar información sobre estudios, centros, becas y otros servicios relacionados con esta materia y su regulación. Además  de Calidad e Innovación educativa, centros y servicios educativos disponibles,',
            :description_2 => 'formación especializada y las becas y ayudas así como otros muchos apartados.',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_04.png'))),
            :external_id => 4

Area.create :name => 'Justicia y Administración Pública',
            :description => 'Le corresponde la preparación y ejecución de la política del Gobierno Vasco. Le corresponde asimismo la política del Gobierno Vasco en materia de función pública y la coordinación de la Administración General del País  en toda la Comunidad Autónoma. Éste es el punto de partida para consultar los servicios de las diferentes administraciones públicas.',
            :description_1 => 'Le corresponde la preparación y ejecución de la política del Gobierno Vasco. Le corresponde asimismo la política del Gobierno Vasco en materia de función pública y la coordinación de la Administración General del País  en toda la Comunidad Autónoma. Éste es el punto de',
            :description_2 => 'partida para consultar los servicios de las diferentes administraciones públicas.',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_05.png'))),
            :external_id => 5

Area.create :name => 'Vivienda, Obras Públicas y Transportes',
            :description => 'Es el departamento encargado de la preparación y ejecución de la política del Gobierno en materia de infraestructuras de transporte terrestre, aéreo y marítimo, y el control, la ordenación y la regulación administrativa de los servicios de transporte correspondientes; la ordenación y dirección de todos los servicios postales y telegráficos.',
            :description_1 => 'Es el departamento encargado de la preparación y ejecución de la política del Gobierno en materia de infraestructuras de transporte terrestre, aéreo y marítimo, y el control, la ordenación y la regulación administrativa de los servicios de transporte correspondientes, la',
            :description_2 => 'ordenación y dirección de todos los servicios postales y telegráficos.',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_06.png'))),
            :external_id => 6

Area.create :name => 'Industria, Innovación, Comercio y Turismo',
            :description => 'Un objetivo prioritario de la Dirección de Turismo es reconocer el carácter estratégico del turismo e impulsarlo decididamente como industria. Para ello, busca activar a su vez el desarrollo de otras industrias y contribuir en la mejora de la calidad de vida de la población, generando notoriedad y proyectando  una imagen de Euskadi en el mundo.',
            :description_1 => 'Un objetivo prioritario de la Dirección de Turismo es reconocer el carácter estratégico del turismo e impulsarlo decididamente como industria. Para ello, busca activar a su vez el desarrollo de otras industrias y contribuir en la mejora de la calidad de vida de la población,',
            :description_2 => 'generando notoriedad y proyectando  una imagen de Euskadi en el mundo.',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_07.png'))),
            :external_id => 7

Area.create :name => 'Empleo y Asuntos Sociales',
            :description => 'La misión de la Dirección de Servicios Sociales es el desarrollo y fortalecimiento del Sistema Público Vasco de los Servicios Sociales, como un sistema estructurado y homogéneo en todo el territorio, que proporcione seguridad jurídica e igualdad en el acceso a sus servicios a toda la Cuidadanía Vasca, desarrollando un trabajo en red con los agentes implicados en su gestión.',
            :description_1 => 'La misión de la Dirección de Servicios Sociales es el desarrollo y fortalecimiento del Sistema Público Vasco de los Servicios Sociales, como un sistema estructurado y homogéneo en todo el territorio, que proporcione seguridad jurídica e igualdad en el acceso a sus servicios a toda la',
            :description_2 => 'Cuidadanía Vasca, desarrollando un trabajo en red con los agentes implicados en su gestión.',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_08.png'))),
            :external_id => 8

Area.create :name => 'Sanidad y Consumo',
            :description => '',
            :description_1 => '',
            :description_2 => '',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_09.png'))),
            :external_id => 9

Area.create :name => 'Medio Ambiente, Planificación Territorial, Agricultura y Pesca',
            :description => 'Se encargan de la regulación de las técnicas de explotación agrícola y ganadera, las ayudas para el desarrollo rural, la gestión del agua de riego, la pesca y la preservación del medio marino, la normativa del sector agroalimentario ... En este apartado encontrará todo lo que tenga que ver con estos sectores productivos.',
            :description_1 => 'Se encargan de la regulación de las técnicas de explotación agrícola y ganadera, las ayudas para el desarrollo rural, la gestión del agua de riego, la pesca y la preservación del medio marino, la normativa del sector agroalimentario ... En',
            :description_2 => 'este apartado encontrará todo lo que tenga que ver con estos sectores productivos.',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_10.png'))),
            :external_id => 10


Area.create :name => 'Cultura',
            :description => 'A este departamento le corresponden las siguientes funciones y áreas de actuación: deportes, juventud, gestión y protección del Patrimonio Artístico, museos, política linguística, promoción del euskera, actividades artísticas y culturales. Dirigir los organismos autónomos, entes públicos de derecho privado y sociedades públicas adscritos o dependientes del Departamento.',
            :description_1 => 'A este departamento le corresponden las siguientes funciones y áreas de actuación: deportes, juventud, gestión y protección del Patrimonio Artístico, museos, política linguística, promoción del euskera, actividades artísticas y culturales. Dirigir los organismos autónomos, entes',
            :description_2 => 'públicos de derecho privado y sociedades públicas adscritos o dependientes del Departamento.',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_11.png'))),
            :external_id => 11

Area.create :name => 'Gobierno Abierto',
            :name_es => 'Gobierno Abierto',
            :name_eu => 'Gobierno Abierto',
            :name_en => 'Gobierno Abierto',
            :description => '',
            :description_1 => '',
            :description_2 => '',
            :image    => Image.create(:image => File.open(Rails.root.join('db/seeds/support/images/area_12.png')))

puts '=> areas loaded'

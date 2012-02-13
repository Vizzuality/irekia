#encoding: UTF-8
module Irekia

  module XMLEntities

    class Organization
      include SAXMachine

      element :title
      element :link
    end

    class AttachmentItem
      include SAXMachine

      element :file_type
      element :url
      element :utl
      element :size
    end

    class Attachment
      include SAXMachine

      elements :item, :class => AttachmentItem
    end

  end

  class Importer

    def self.get_news_from_rss(since = nil)
      puts ''
      puts 'Importing news from Irekia'
      puts '============================'

      last_news_date = since || 1.day.ago

      Feedzirra::Feed.add_common_feed_entry_element('organization',          :as => :organization,          :class => Irekia::XMLEntities::Organization)
      Feedzirra::Feed.add_common_feed_entry_element('multimedia_iframe_src', :as => :multimedia_iframe_src)
      Feedzirra::Feed.add_common_feed_entry_element('attached_files',        :as => :attached_files,        :class => Irekia::XMLEntities::Attachment)
      Feedzirra::Feed.add_common_feed_entry_element('audios',                :as => :audios,                :class => Irekia::XMLEntities::Attachment)
      Feedzirra::Feed.add_common_feed_entry_element('videos_hq',             :as => :videos_hq,             :class => Irekia::XMLEntities::Attachment)

      news_feed_url        = lambda{|lang| "http://www.irekia.euskadi.net/#{lang}/news/news.rss"}


      %w(es eu en).each do |lang|

        puts ''
        puts "=> reading and parsing the rss feed for language '#{lang}'"

        url = news_feed_url.call(lang) + "?since=#{last_news_date.strftime('%Y%m%d')}" if last_news_date.present?

        feed = Feedzirra::Feed.fetch_and_parse(url)
        news_entries = feed.entries

        puts "=> loading #{news_entries.count} news found"
        news_entries.each do |news_item|
          begin

            news = News.find_or_initialize_by_external_id(news_item.entry_id)
            news.news_data            = NewsData.new if news.news_data.blank?
            news.news_data.send(:"title_#{lang}=", (news_item.title.sanitize rescue nil))
            news.news_data.send(:"body_#{lang}=",(news_item.summary.sanitize rescue nil))
            news.published_at         = news_item.published || Time.now
            news.news_data.source_url = news_item.url rescue nil
            news.news_data.iframe_url = news_item.multimedia_iframe_src rescue nil
            news.tags                 = news_item.categories.reject{|t| t.match(/^_/) || t.match(/::/)}.join(',')
            news.moderated            = true

            if news.new_record?
              news.areas = []
              area_name = news_item.organization.title == 'Presidencia' ? 'Lehendakaritza' : news_item.organization.title if news_item.organization.present? && news_item.organization.title.present?
              news.areas << Area.where("name_#{lang} like ? OR name like ?", "%#{area_name}%", "%#{area_name}%").first rescue puts "Invalid área name: #{area_name}" if area_name.present?
            end

            news_item.categories.each do |category|
              news.users << User.where('name || ' ' || lastname = ? AND id not in (?)', category, news.users_ids).first rescue nil
            end

            if news_item.audios.present?
              news.audio_attachments.destroy_all
              (news_item.audios.item || []).each do |attachment|
                news.audio_attachments << AudioAttachment.create(
                  :name      => (URI.parse(attachment.url).path.split(%r{/+}, -1).last rescue nil),
                  :url       => attachment.url,
                  :size      => attachment.size
                )
              end
            end

            if news_item.videos_hq.present?
              news.video_attachments.destroy_all
              (news_item.videos_hq.item || []).each do |attachment|
                news.video_attachments << VideoAttachment.create(
                  :name      => (URI.parse(attachment.utl).path.split(%r{/+}, -1).last rescue nil),
                  :url       => attachment.utl,
                  :size      => attachment.size
                )
              end
            end

            if news_item.attached_files.present?
              news.file_attachments.destroy_all
              (news_item.attached_files.item || []).each do |attachment|
                news.file_attachments << FileAttachment.create(
                  :name      => (URI.parse(attachment.url).path.split(%r{/+}, -1).last rescue nil),
                  :file_type => attachment.file_type,
                  :url       => attachment.url,
                  :size      => attachment.size
                )
              end
            end

            news.save!
            print '.'
          rescue Exception => ex
            puts ex
            puts ex.backtrace
          end
        end
      end
    puts ''
    puts '=> import complete!'
    rescue Exception => ex
      puts ex
      puts ex.backtrace
    end

    #BEGIN:VEVENT
    #CREATED;VALUE=DATE-TIME:20111023T184057Z
    #DTEND;VALUE=DATE-TIME:20111024T093000Z
    #STATUS:TENTATIVE
    #DTSTART;VALUE=DATE-TIME:20111024T090000Z
    #DTSTAMP;VALUE=DATE-TIME:20111123T183827Z
    #LAST-MODIFIED;VALUE=DATE-TIME:20111109T122444Z
    #UID:uid_7807_irekia_euskadi_net
    #DESCRIPTION:Presidencia.\nLehendakari.\nEl Lehendakari\, Patxi López\, se reunirá mañana\, a las 11:00\, Iñigo Urkullu en Lehendakaritza como comienzo de la ronda de partidos para analizar la situación tras el comunicado de ETA.\nTras el cese definitivo de la actividad armada\, el Lehendakari anunció el inicio de una ronda de reuniones con los partidos que empezará mañana con su encuentro con el presidente del PNV.\nLos medios gráficos podrán tomar imágenes del encuentro.
    #URL:http://www.irekia.euskadi.net/es/events/7807-lehendakari-comienza-ronda-partidos
    #SUMMARY:El Lehendakari comienza la ronda de partidos
    #LOCATION:Lehendakaritza\, Vitoria-Gasteiz
    #SEQUENCE:3
    #END:VEVENT
    def self.get_events_from_ics
      require 'open-uri'

      puts ''
      puts 'Importing events from Irekia'
      puts '============================'

      puts '=> reading feeds'

      events_ics_url   = lambda{|lang| "http://www.irekia.euskadi.net/#{lang}/events/myfeed.ics?dept_label=all"}
      event_detail_url = lambda{|event_id| "http://www.irekia.euskadi.net/es/events/#{event_id}.xml"}

      %w(es eu en).each do |lang|
        open(events_ics_url.call(lang)) do |ical_file|
          I18n.locale = lang
          puts '=> parsing calendar file'
          calendar = RiCal.parse_string(ical_file.read).first rescue nil
          events = calendar.events
          puts "=> loading #{events.count} events found"
          events.each do |event_data|
            event_uid = event_data.uid[/uid_(\d*)_irekia_euskadi_net/, 1]
            event_data_detail = Nokogiri::Slop(open(event_detail_url.call(event_uid)).read)

            begin
              event_data_model = EventData.find_by_external_id(event_uid) || EventData.new

              event_data_model.send(:"title_#{lang}=", (event_data.summary.sanitize rescue nil))
              event_data_model.send(:"body_#{lang}=",(event_data.description.sanitize rescue nil))
              event_data_model.event_date  = event_data.dtstart
              event_data_model.duration    = event_data.dtend - event_data.dtstart
              event_data_model.external_id = event_uid
              event_data_model.place       = event_data_detail.event.lugar.text

              case event_data_detail.event.cobertura.estado.text
              when 'anunciado'
                event_data_model.create_image(:remote_image_url => event_data_detail.event.cobertura.imagen.text)
              when 'emitiendo'
                event_data_model.html = open(event_data_detail.event.cobertura.iframe_src.text).read
              when 'noticia'
                event_data_model.news_url = event_data_detail.event.cobertura.url.text
              end

              event = event_data_model.event || Event.new

              if event.new_record?
                area_name = event_data_detail.event.organismo.title.text.strip == 'Presidencia' ? 'Lehendakaritza' : event_data_detail.event.organismo.title.text.strip if event_data_detail.event.organismo.title.text.strip.present? rescue nil
                event.areas << Area.where("name like ? OR name_es like ? OR name_eu like ? OR name_en like ?", *(["%#{area_name}%"] * 4)).first rescue puts "Invalid área name: #{area_name}"
                event_data_detail.event.tags.search('tag').each do |tag|
                  event.areas << Area.find_by_name(tag.text.strip) rescue nil
                  event.users << User.where('name || ' ' || lastname = ?', tag.text.strip).first rescue nil
                end
                event_data_detail.event.asisten.text.split(',').each do |politician|
                  event.users << User.where('name || ' ' || lastname like ? AND id not in (?)', "%#{category}%", event.users_ids).first rescue nil
                end
              end

              event.event_data = event_data_model
              event.location   = event_data.location
              event.latitude   = event_data_detail.event.lat.text
              event.longitude  = event_data_detail.event.lng.text
              event.location   = event_data_detail.event.direccion.text
              event.tags       = event_data_detail.event.tags.tag.map{|tag| tag.text.strip }.reject{|t| t.match(/^_/) || t.match(/::/)}.join(',')
              event.moderated  = true

              event.save!

              print '.'
            rescue Exception => e
              puts e
              puts e.backtrace
            end
          end
        end
        puts ''
        puts '=> import complete!'
      end

    rescue Exception => e
      puts e
      puts e.backtrace
    end

    def self.get_areas_and_politicians
      puts ''
      puts "Importing politicians' data from communication guide"
      puts '===================================================='
      require 'open-uri'

      languages             = %w(es eu)
      server                = 'http://www2.irekia.euskadi.net'
      categories_url        = lambda{ |language| "#{server}/#{language}/categories.json" }
      areas_url             = lambda{ |language, id| "#{server}/#{language}/categories/#{id}.json" }
      area_detail_url       = lambda{ |language, id| "#{server}/#{language}/entities/#{id}.json" }

      politicians_inserted = areas_processed = []
      politicians_ids    = Area.where('external_id is not null').inject({}){|h, a| h[a.external_id] = []; h}
      area_relationships = Area.where('external_id is not null').inject({}){|h, a| h[a.external_id] = []; h}

      puts ''
      puts '* Loading areas...'
      puts ''
      languages.each do |lang|
        begin
          puts "=> getting data for #{lang} language"
          puts "=> getting all categories"
          categories = get_json(categories_url.call(lang), 'categories')

          basque_government = categories.select{|c| ['gobierno vasco', 'eusko jaurlaritza'].include?((c['name'] || '').downcase.strip)}.first
          if basque_government.present?

            puts '=> getting all government areas'
            areas = get_json(areas_url.call(lang, basque_government['id']), 'categories')

            areas.each do |area|
              area_id = area['id']
              area_detail = get_json(area_detail_url.call(lang, area_id))
              area_name = area['name'].gsub(/^Departamento de /, '')

              politicians_ids[area_id]    += (area_detail['people'].map(&:first) || []) if politicians_ids.has_key?(area_id)
              area_relationships[area_id] << area_detail['relationships'] if area_relationships.has_key?(area_id)

              Area.where(:external_id => area_id).each do |area_model|
                if area_model.lehendakaritza?
                  area_model.send("name_#{lang}=", 'Lehendakaritza')
                else
                  area_model.send("name_#{lang}=", area_name)
                end
                area_model.set_friendly_id(area_name, lang.to_sym)
                area_model.save!
              end

            end
          end
        rescue Exception => ex
          puts ex
          puts ex.backtrace
        end
      end

      puts ''
      puts '* Loading politicians...'
      puts ''
      Area.where('external_id is not null').order('external_id asc').each do |area_model|
        next if area_model.nil?

        puts "=> getting politicians data for #{area_model.id} - #{area_model.name}"

        area_relationships[area_model.external_id].flatten.map{|r| r['items']}.flatten.compact.uniq.reject{|r| Area.all.map(&:external_id).include?(r['id']) || areas_processed.include?(r['id'])}.each do |area_relationship|
          puts "\t=> getting politicians data for area relationship #{area_relationship['id']}"
          area_relationship_detail = get_json(area_detail_url.call('es', area_relationship['id']))
          politicians_ids[area_model.external_id] += area_relationship_detail['people'].map(&:first)
          areas_processed                         << area_relationship['id']
        end

        politicians_ids[area_model.external_id].flatten.uniq.compact.reject{|id| politicians_inserted.include?(id)}.each do |politician_id|
          languages.each do |lang|
            create_politician(lang, politician_id, area_model)
          end
          politicians_inserted << politician_id
        end
      end

      AreaUser.where(:user_id => User.patxi_and_advisers.map(&:id)).update_all(:display_order => 1)

      puts '=> import complete!'
    end

    #id;Email;Contraseña;Salt;Twitter screen_name;Twitter atoken;Twitter asecret;Facebook ID;Nombre;Apellidos;Tipo;Departamento;Lugar;Código postal;Provincia;Ciudad
    def self.import_users
      puts ''
      puts 'Importing users'
      puts '==============='
      require 'csv'

      columns = %w(email encrypted_password salt twitter_username twitter_oauth_token twitter_oauth_token_secret facebook_oauth_token name lastname postal_code province city external_id)

      CSV.foreach(Rails.root.join('db/seeds/support/datos_usuarios.csv'), :col_sep => ';', :headers => :first_row) do |row|

        begin

          next if User.find_by_external_id(row['id'])

          user = {}

          user[:email]                      = row['Email']
          user[:encrypted_password]         = row['Password']
          user[:salt]                       = row['Salt']
          user[:twitter_username]           = row['Twitter screen_name']
          user[:twitter_oauth_token]        = row['Twitter atoken']
          user[:twitter_oauth_token_secret] = row['Twitter asecret']
          user[:facebook_oauth_token]       = row['Facebook ID']
          user[:name]                       = row['Nombre']
          user[:lastname]                   = row['Apellidos'] || ' '
          user[:postal_code]                = row['Codigo postal']
          user[:province]                   = row['Provincia']
          user[:city]                       = row['Ciudad']
          user[:external_id]                = row['id']

          User.import user.reject{|k,v| v.blank?}.keys, [user.reject{|k,v| v.blank?}.values], :validate => false

          print '.'

        rescue Exception => ex
          puts ex
          puts ex.backtrace
        end

      end

    end

    def self.import_proposals
      puts ''
      puts 'Importing old proposals'
      puts '======================='
      require 'csv'

      culture_area = Area.find_by_name('Cultura')

      rows = CSV.read(Rails.root.join('db/seeds/support/proposals.csv'), :headers => :first_row)
      rows.each do |row|

        begin
          next if row['status'].downcase == 'pendiente'

          author = User.find_by_external_id(row['user_id'])

          next if author.blank?

          proposal_data = ProposalData.find_or_initialize_by_external_id(row['id'])
          if proposal_data.new_record?
            proposal_data.title_es    = row["title_es"].force_encoding('utf-8')
            proposal_data.title_eu    = row["title_eu"].force_encoding('utf-8')
            proposal_data.title_en    = row["title_en"].force_encoding('utf-8')
            proposal_data.body_es     = row["body_es"].force_encoding('utf-8')
            proposal_data.body_eu     = row["body_eu"].force_encoding('utf-8')
            proposal_data.body_en     = row["body_en"].force_encoding('utf-8')
            proposal_data.target_area = culture_area

            if proposal_data.proposal.blank?
              proposal = Proposal.new
              proposal.author = author
              proposal.proposal_data = proposal_data
              proposal.moderated = true
              proposal.save!
            end

            proposal_data.save!

            print '.'
          end

        rescue Exception => ex
          puts ex
          puts ex.backtrace
        end

      end

    end

    def self.update_areas_and_politicians_descriptions
      areas_texts = {
        'es' => {
          '1' => ['La Secretaría General de Presidencia del Gobierno Vasco tiene como función la cobertura logística, técnica y de asesoramiento del Lehendakari en el desempeño de sus funciones, así como el liderazgo, coordinación y asesoramiento del resto de Departamentos del Gobierno Vasco.', 'De la Secretaría General de Presidencia depende, asimismo, la gestión de la Acción Exterior del Gobierno Vasco, la Agencia Vasca de Cooperación al Desarrollo y Emakunde.'],
          '2' => ['Objetivos: consolidar la paz y la libertad en una Euskadi sin terrorismo, luchar contra la delincuencia y el crimen organizado, atender a las víctimas del terrorismo, erradicar la violencia de género, mejorar la seguridad vial y reducir la siniestralidad, garantizar la máxima calidad en la atención de emergencias y en la labores', 'de protección civil, promover el juego responsable y la seguridad en los espectáculos y gestionar con eficacia los procesos electorales.'],
          '3' => ['Se ocupa de la planificación económica y presupuestaria: diseño de la política financiera y tributaria, gestión del presupuesto y de la deuda pública, relaciones con las entidades financieras, control del Patrimonio del Gobierno y las políticas de Contratación Publica. Otras de sus áreas de actuación y competencia  son', 'el  Concierto Económico, el Cupo, las aportaciones de las Diputaciones, la estadística y análisis de la economía vasca y la coordinación de fondos europeos.'],
          '4' => ['Gestiona la oferta de toda la educación reglada, los centros educativos públicos, la universidad pública y la financiación de los concertados. Oferta las becas de estudio y asegura que todas las personas tengan un acceso universal e igualitario a la educación. Coordina los organismos de apoyo al profesorado y el personal de', 'todos los centros. Por último, es el garante de la política científica y gestor de los fondos públicos dedicados a la investigación básica y aplicada.'],
          '5' => ['Su labor se centra en atender las relaciones con el Poder Judicial, la defensa jurídica del Estatuto de Autonomía, la atención de los centros penitenciarios, la organización administrativa dentro del Ejecutivo, la modernización de la administración electrónica, la garantía al', 'acceso a la Justicia en euskera y múltiples funciones derivadas de la gestión de la actividad legal, jurídica y administrativa del Ejecutivo.'],
          '6' => ['Por un lado, el área de Vivienda facilita el acceso de la ciudadanía a la vivienda a través de la promoción de vivienda protegida, de la gestión de ayudas, de políticas de  rehabilitación, gestión del suelo y fomento de la innovación en la construcción. Por otro, el área de Obras Públicas y Transporte persigue la mejora', 'de la interconexión de los sistemas de transporte (ferroviario, terrestre, marítimos, fluviales, por cable y aéreos) a través de una política integral y sostenible del transporte.'],
          '7' => ['Le corresponden las siguientes funciones y áreas de actuación: política industrial, innovación tecnológica, internacionalización, promoción y desarrollo de la Sociedad de la Información y del Conocimiento en la sociedad vasca, minas, energía, comercio, tutela a las Cámaras de Comercio; turismo, además', 'de dirigir sociedades públicas como SPRI (Sociedad para la Transformación Competitiva), EVE (Ente Vasco de la Energía) y Basquetour (Agencia Vasca de Turismo). '],
          '8' => ['', ''],
          '9' => ['Se ocupa de identificar las prioridades sanitarias en el País Vasco, regular la asistencia sanitaria que prestan el sector público y privado con el objetivo de garantizar la calidad en los servicios prestados, financiar la asistencia sanitaria en Osakidetza y defender los derechos de los consumidores a través de', 'Kontsumobide. Además, aborda un cambio del modelo sanitario orientado a los pacientes crónicos con la Estrategia para Abordar el Reto de la Cronicidad en Euskadi.'],
          '10' => ['', ''],
          '11' => ['Actúa en áreas relacionadas con el deporte, la juventud, la protección del Patrimonio Histórico Artístico, museos, bibliotecas y archivos, la política lingüística y la promoción del euskera, las actividades artísticas y culturales, y su difusión, los medios de comunicación social y la ', 'dirección de los organismos autónomos, entes y sociedades públicas adscritos o dependientes del Departamento.'],
        },
        'eu' => {
          '1' => ['Eusko Jaurlaritzako Lehendakaritzaren Idazkaritza Nagusiaren eginkizuna da Lehendakariari hornidura logistikoa eta teknikoa eta aholkularitza ematea, beraren eginkizunak betetzeko lanean, eta, horrekin batera, Eusko Jaurlaritzako gainerako Sailak gidatzea, koordinatzea eta Sail horiei aholkularitza ematea. Lehendakaritzaren ', 'Idazkaritza Nagusiaren mende daude, halaber, Eusko Jaurlaritzako Kanpo Harremanen kudeaketa, Garapenerako Lankidetzaren Euskal Agentzia eta Emakunde.'],
          '2' => ['Helburu nagusiak: bakea eta askatasuna Euskadin sendotzea, terrorismoa desagertu ondoren, delinkuentzia eta krimen antolatuaren aurka borrokatzea, terrorismoaren biktimei arreta ematea, genero indarkeria desagerraraztea, bide-segurtasuna hobetzea eta istripuak murriztea, kalitaterik handiena bermatzea', 'larrialdien arretan eta babes zibileko zereginetan, joko arduratsua eta ikuskizunetako segurtasuna sustatzea, eta hauteskunde-prozesuak eraginkortasunez kudeatzea. '],
          '3' => ['Ekonomiaren eta aurrekontuen plangintzaz arduratzen da: finantza- eta zerga-politikaren diseinua, aurrekontuaren eta zor publikoaren kudeaketa, finantza-erakundeekiko harremanak, Jaurlaritzaren Ondarearen kontrola, eta Kontratazio Publikoaren politikak. Bere jarduera eta eskumenen beste alor batzuk hauexek', 'dira: Kontzertu Ekonomikoa, Kupoa, Aldundien ekarpenak, estatistika, euskal ekonomiaren analisiari buruzko azterlanak, eta europar funtsen koordinazioa.'],
          '4' => ['Hezkuntza arautu osoa zuzentzen du, ikastetxe publikoak kudeatu eta ikastetxe itunduak eta unibertsitatea finantzatzen ditu. Ikasketarako bekak kudeatzen ditu, eta segurtatzen du pertsona guztiek badutela sarbide unibertsala hezkuntzara, aukera berdinetan. Irakasleei laguntzeko erakundeak koordinatzen ditu. Bukatzeko, ', 'politika zientifikoaren bermatzailea da, eta oinarrizko ikerketara eta ikerketa aplikatura Euskadin zuzentzen diren funts publikoak kudeatzen ditu.'],
          '5' => ['Sail honetan biltzen dira Justizia, Herri Administrazio, Araubide Juridiko eta Funtzio Publikoaren sailburuordetzak. Alor honen eginkizunaren ardatzak dira Botere Judizialarekiko harremanei arreta ematea, Autonomia Estatutuaren defentsa juridikoa egitea, espetxeentzako arreta, Jaurlaritzaren barneko antolaketa administratiboa, administrazio elektronikoa', 'modernizatzeko prozesua bultzatzea, Justiziara euskaraz iristeko bidea bermatzea, eta Jaurlaritzaren jarduera legal, juridiko eta administratibotik ondorioztatzen diren hainbat eginkizun betetzea. '],
          '6' => ['Alde batetik, etxebizitzaren eremuak etxebizitza duina eskuratzeko laguntza eman nahi die hiritarrei, etxebizitza babestuen sustapenaren, laguntzen kudeaketaren, zaharberritze politiken, lurzoruaren kudeaketaren, eraikuntzaren berrikuntza eta kalitatearen sustapenaren eta irisgarritasunaren sustapenaren bidez. Beste alde batetik, garraioaren eremuak', 'lurraldearen egituraketa eta garraio sistemen (trenbidea, lehorreko, itsasoko eta ibaiko garraioa, kablearen bidezko garraioa) elkar loturaren hobekuntza bilatzen ditu, garraioari buruzko politika integral eta iraunkorraren.'],
          '7' => ['Eginkizun eta jarduera-eremu hauek dagozkio: politika industriala, berrikuntza teknologikoa, internazionalizazioa, Informazioaren eta Ezagutzaren Gizartea euskal gizartean sustatzea eta garatzea, meategiak, energia, merkataritza, Merkataritza Ganberen tutoretza, eta turismoa; horrez gain, SPRI (Eraldaketa', 'Lehiakorrerako Sozietatea), EEE (Energiaren Euskal Erakundea) eta Basquetour (Turismoaren Euskal Agentzia) moduko sozietate publikoak ere zuzentzen ditu. '],
          '8' => ['', ''],
          '9' => ['Bere zeregina da Euskadiko osasunaren alorreko lehentasunak identifikatzea eta osasun maila hobetzen saiatzeko jarduerak garatzea. Osasun Plana lantzeaz arduratzen den organoa da. Batez ere Osakidetzak ematen duen osasun arreta finantzatzea, Kontsumitzaileen eskubideak defendatzea, Kontsumobideren bitartez.', 'Hori guztia osasun eredua aldatzeko prozesu batean oinarrituta, paziente kronikoen arretara zuzenduta, Euskadiko Kronikotasunaren Erronkari heltzeko Estrategian planteatzen den bezala.'],
          '10' => ['', ''],
          '11' => ['Gai hauekin zerikusia duten arloen kudeaketa dago: kirola, gazteria, Ondare Historiko Artistikoaren babesa, liburutegia eta artxiboak, hizkuntza politika eta euskararen sustapena, jarduera artistiko eta kulturalak eta haien hedapena, hedabide sozialak, emisoreak baimentzeari eta frekuentziak asignatzeari dagokionez,', 'eta Sail honi atxikita dauden edo beraren mende dauden erakunde autonomoen, zuzenbide pribatuko erakunde publikoen eta sozietate publikoen zuzendaritza. '],
        }
      }
      # updates descriptions and icons for all areas
      Area.where('external_id is not null').order('external_id asc').each do |area|
        %w(es eu).each do |lang|
          area.send("description_1_#{lang}=", areas_texts[lang][area.external_id.to_s][0])
          area.send("description_2_#{lang}=", areas_texts[lang][area.external_id.to_s][1])
        end
        area.image = Image.create(:image => File.open(Rails.root.join("db/seeds/support/images/area_#{"%02d" % area.external_id}.png")))
        area.save!
      end

      politicians_texts = [
        ["Isabel Celaá", 6928, {"es"=>["Nacida en Bilbao en 1949. Ha promovido la renovación del sistema educativo vasco, tanto en el ámbito lingüístico, gracias al Marco de Educación Trilingüe, como en el tecnológico, con la introducción del proyecto Eskola 2.0. Su gestión también se caracteriza por una apuesta firme por la Formación Profesional, vertiente en la que ", "destacan la aprobación del III plan vasco de FP y la nueva ley de aprendizaje a lo largo de la vida, y por su apoyo a la investigación científica."], "eu"=>["Bilbon jaio zen 1949an. Euskal hezkuntza sistemaren berrikuntza bultzatu du, bai hizkuntzaren alorrean, Hezkuntza Hirueledunaren Esparruari esker, eta bai alor teknologikoan, Eskola 2.0 proiektua abiatzearen bidez. Beraren kudeaketaren beste ezaugarri bat Lanbide Heziketaren aldeko apustu irmoa da; arlo  horretan,", " nabarmentzekoak dira LHaren III. euskal planaren onarpena eta bizitza osorako ikaskuntzari buruzko lege berria, eta baita ikerketa zientifikoari emandako sostengua ere."]}],
        ["Rodolfo Ares", 953, {"es"=>["Nacido en Orense en 1954. Su prioridad ha sido acabar con el terrorismo y consolidar la paz, la libertad y la convivencia en Euskadi. Una política que ha permitido, en colaboración con la ciudadanía, dar pasos hacia el final del terrorismo y de la amenaza permanente de ETA tras 30 años de actividad. Terminar con la violencia machista es otro objetivo prioritario, a", "través de la Dirección de Atención a las Víctimas de la Violencia de Género. Además, se ha impulsado un plan para modernizar la Ertzaintza, garantizando la seguridad en las calles."], "eu"=>["Rodolfo Ares (Ourense, 1954). Bere helburu nagusia terrorismoa ezabatzea izan da, bakea, askatasuna eta elkarbizitza Euskadin behin betiko finkatzeko. Politika horri esker, herritarren lankidetzarekin, urratsak egin ahal izan dira terrorismoaren eta ETAren etengabeko mehatxuaren amaierarantz, 30 urteko jardueraren ostean. Lehentasuna duen beste helburu ", "bat indarkeria matxista desagerraraztea da, Genero Indarkeriaren Biktimei Laguntzeko Zuzendaritzaren bidez. Gainera, Ertzaintza modernizatzeko plan bat bultzatu da, kaleetako segurtasuna bermatzeko xedez. "]}],
        ["Carlos Aguirre", 169, {"es"=>["Nacido en Bilbao, 1956. Impulsó la Ley de Medidas Presupuestarias Urgentes (aprobada en septiembre de 2009), las Leyes de  Presupuestos Generales de la CAPV del 2009, 2010 y 2011 y la Ley de Cajas, de Tasas y Precios,  de Entidades Participadas y de EPSVs. Asimismo ha", "impulsado herramientas de Transparencia Económico-Administrativa como el Perfil del Contratante, una experiencia pionera en el ámbito de la contratación pública."], "eu"=>["Bilbo, 1956. Premiazko Aurrekontu Neurriei buruzko Legea (2009ko irailean onartua), EAEko 2009, 2010 eta 2011ko Aurrekontu Orokorren onarpena eta Kutxen Legea, Tasa eta Prezioen Legea, Partaidetzazko Erakundeena eta BGAEen Legea bultzatu ditu. Orobat, Gardentasun Ekonomiko-", "administratiborako tresnak bultzatu ditu, hala nola Kontratatzailearen Profila, esperientzia aurrendari bat kontratazio publikoaren alorrean."]}],
        ["Blanca Urgell", 6936, {"es"=>["Nacida en Vitoria-Gasteiz en 1962. En esta primera parte de la legislatura se ha presentado el Proyecto de Ley de Juventud, se está trabajando en el III Plan Joven, se ha aprobado el Proyecto de Ley contra del dopaje en el deporte y se ha impulsado la candidatura del Camino del Norte", "a Patrimonio de la Humanidad. Se ha consolidado el Instituto Etxepare como promotor de la lengua y cultura vascas en un mundo global. "], "eu"=>["Vitoria-Gasteizen jaio zen 1962an. Legealdiaren lehenengo zati honetan, Gazteriaren Legearen Proiektua aurkeztu da, III. Gazte Plana lantzen ari da, kirolean dopatzearen aurkako Lege Proiektua onartu da, eta Iparraldeko Bidearen hautagaitza bultzatu da Gizateriaren", "Ondare izateko. Etxepare Institutua sendotu da, euskararen eta euskal kulturaren eragile bezala, mundu globalean."]}],
        ["Patxi López", 8080, {"es"=>["Nacido en Portugalete en 1959. Tomó posesión de su cargo el 7 de mayo de 2009.  Sus objetivos han sido dar normalidad a la política vasca, luchar contra el terrorismo hacer frente a la crisis ayudando a la generación de empleo y al crecimiento de la economía, y poner las bases de una Euskadi solidaria, sostenible y competitiva.", "Una de las prioridades del Lehendakari es la consolidación de la libertad y la convivencia democrática en la sociedad vasca desde las bases de la unidad, la concordia y la memoria."], "eu"=>["Portugalete, 1959. 2009ko maiatzaren 7an hartu zuen bere kargua. Bere helburu nagusiak euskal politikari normaltasuna ematea, terrorismoaren aurka borrokatzea, krisiari aurre egitea, enpleguaren sorrerari eta ekonomiaren hazkundeari lagunduz, eta Euskadi solidario, iraunkor eta lehiakorraren oinarriak jartzea.", "Lehendakariaren lehentasunetako bat da askatasuna eta elkarbizitza demokratikoa euskal gizartean sendotzea, batasuna, adostasuna eta oroimena oinarritzat hartuta."]}],
        ["Iñaki Arriola", 7552, {"es"=>["Nacido en EIbar en 1959. Durante su mandato como consejero se ha dado un fuerte impulso a las obras del Tren de Alta Velocidad en Gipuzkoa y ha promovido el Metro de Donostialdea, un proyecto con el que se pretende llegar a 30 millones de viajeros y dar servicio directo o indirecto a", "más del 70% de la población guipuzcoana. Este año presentará en el consejo de Gobierno el Anteproyecto de Ley de Vivienda."], "eu"=>["Eibar, 1959. Sailburua izan den garaian, bultzada handia eman zaie Abiadura Handiko Trenaren obrei, Gipuzkoako tartean, eta Donostialdeako Metroa sustatu da; proiektu horren asmoa da 30 milioi bidaiarirengana iristea eta zuzeneko edo zeharkako zerbitzua ematea Gipuzkoako ", "biztanleriaren %70ri. Aurten, Etxebizitzaren Legearen Aurreproiektua aurkeztuko du Gobernu kontseiluan. "]}],
        ["Gemma Zabaleta", 7335, {"es"=>["Nacida en Donostia en 1957. Su principal apuesta es ligar la prestación de las ayudas sociales con la activación por el empleo, para lo que Lanbide se ha hecho cargo de la gestión de la Renta de Garantía de Ingresos, que hasta ahora estaba en manos de los servicios sociales de los ayuntamientos y de las diputaciones. En cuanto a las", "políticas activas de empleo, el empeño es que  Lanbide ofrezca una orientación personalizada a todos los ciudadanos que lo demanden, lo que supone una de sus principales señas de identidad."], "eu"=>["Donostian jaio zen 1957ean. Bere apustu nagusia da gizarte laguntzen prestazioa enpleguaren aktibazioarekin uztartzea; horri begira, Lanbidek bere gain hartu du Diru-sarrerak Bermatzeko Errentaren kudeaketa, orain arte udal eta aldundien gizarte zerbitzuen eskuetan baitzeuden. Enplegurako politika aktiboei dagokienez,", "asmoa da Lanbidek orientabide pertsonalizatua eskaintzea hori eskatzen dute hiritar guztiei. Izan ere, hori da beraren identitatearen ezaugarri nagusietako bat. "]}],
        ["Idoia Mendia", 3955, {"es"=>["Nacida en Bilbao en 1965. Ejerce las labores de portavoz del Gobierno Vasco y está al frente del departamento de Justicia y Administración Pública. La modernización de la Administración de Justicia es uno de sus objetivos prioritarios. Es responsable de la gestión de las webs gubernamentales. Entre sus", "iniciativas destacan proyectos como Open Data Euskadi, el Plan de Innovación Pública 2011 - 2013 y la novedosa experiencia de teletrabajo."], "eu"=>["Bilbo, 1965. Eusko Jaurlaritzako bozeramailea ere bada. Justizia Administrazioaren modernizazioa bere lehentasunezko helburuetako bat da. Jaurlaritzaren webguneen kudeaketaz arduratzen da. Bere ekimenen artean azpimarratzekoa da Open Data Euskadi", "proiektua, Eusko Jaurlaritzaren Berrikuntza Publikorako Plana (2011-2013) telelan esperientzia berritzailea martxan jarri ditu. "]}],
        ["Bernabé Unda", 7299, {"es"=>["Nacido en Bilbao en 1956, es ingeniero naval y uno de los consejeros independientes del Gobierno de Patxi López. Ha impulsado el Plan de Competitividad Empresarial 2010-13 del Gobierno Vasco, así como otras iniciativas como la Estrategia Energética de Euskadi", "2020, y actuaciones concretas en apoyo del tejido empresarial y del empleo como las derivadas de las Estrategias Resiste, Compite y Lidera."], "eu"=>["Bilbon 1956an jaioa, ontzigintza-ingeniaria da eta Patxi Lópezen Gobernuaren sailburu independenteetako bat. Eusko Jaurlaritzaren 2011-13ko  Enpresa Lehiakortasunerako Plana bultzatu du, eta baita beste ekimen batzuk ere, hala nola, Euskadiko 2020 Energia Estrategia eta", "enpresa-sareari eta enpleguari laguntzeko jarduera konkretuak; adibidez: Eutsi, Lehiatu eta Gidatu Estrategiak."]}],
        ["Rafael Bengoa", 6934, {"es"=>["Nacido en Bilbao en 1952. Doctor en Medicina de la Universidad del País Vasco, máster en Gestión de Sistemas de Salud y Master en Salud Comunitaria de la Universidad de Londres en Inglaterra, Senior Fellow de la Business School de la Universidad de Manchester en Inglaterra y Diploma Gestión Hospitalaria en Deusto.", "Impulsor de la Estrategia para Afrontar el Reto de la Cronicidad en Euskadi, referencia en todo el Estado como modelo de transformación del sistema sanitario basado en la integración asistencial."], "eu"=>["Bilbon jaio zen 1952an. Medikuntzako Doktorea Euskal Herriko Unibertsitatetik, Osasun Sistemen Kudeaketaren Masterra eta Osasun Komunitarioaren Masterra Ingalaterrako Londresko Unibertsitatetik, Ingalaterrako Manchesterko Unibertsitateko Business Schooleko Senior Fellow, eta Ospitale Kudeaketaren Diploma Deustun. Kronikotasunaren Erronkari", "Euskadin Heltzeko Estrategiaren bultzatzailea; estrategia hori erreferentziazkoa da estatu osoan, osasun sistemaren eraldaketa bideratzen baitu asistentziaren integrazioan oinarrituta. "]}]]

      # updates descriptions and icons for all areas
      politicians_texts.each do |politician_text|
        politician = User.find_by_external_id(politician_text[1])
        %w(es eu).each do |lang|
          politician.send("description_1_#{lang}=", politician_text[2][lang][0])
          politician.send("description_2_#{lang}=", politician_text[2][lang][1])
        end
        politician.save!
      end
    end

    def self.repair_encoding_in_external_proposals
      ProposalData.where('external_id is not null').each do |proposal_data|
        proposal_data.update_attributes :title_es => proposal_data.title_es.force_encoding('utf-8'),
                                        :title_eu => proposal_data.title_eu.force_encoding('utf-8'),
                                        :title_en => proposal_data.title_en.force_encoding('utf-8'),
                                        :body_es  => proposal_data.body_es.force_encoding('utf-8'),
                                        :body_eu  => proposal_data.body_eu.force_encoding('utf-8'),
                                        :body_en  => proposal_data.body_en.force_encoding('utf-8')

        proposal_data.proposal.cancel_notifications = true
        proposal_data.proposal.publish
      end
    end

    def self.update_news_publishing_dates
      puts '=> Updating news publishing dates'
      news_detail_url = lambda{|news_id| "http://www.irekia.euskadi.net/es/news/#{news_id}.xml"}

      i           = 0
      news_count  = News.where('external_id IS NOT NULL').count
      news_detail = nil

      News.select('id, published_at, external_id, slug').where('external_id IS NOT NULL').find_each do |news|

        begin
          news_detail = Nokogiri::XML::Reader(open(news_detail_url.call(news.external_id)).read)
          news_detail.each do |node|
            if node.name == 'pubDate' && node.node_type == 1 && node.inner_xml.present?
              puts "Updating publishing date for news #{news.external_id} to #{node.inner_xml}"
              News.where(:external_id => news.external_id).update_all(:published_at => DateTime.parse(node.inner_xml))
              break
            end
          end
        rescue Exception => ex
          puts ex
          puts ex.backtrace
        end

        i += 1

        print " #{i}/#{news_count}"

        GC.start
      end
    end

    private

    def self.create_politician(lang, politician_id, area_model)
      server                = 'http://www2.irekia.euskadi.net'
      politician_detail_url = lambda{ |language, id| "#{server}/#{language}/people/#{id}.json" }

      begin
        politician = get_json(politician_detail_url.call(lang, politician_id), 'person')

        user = User.find_or_initialize_by_external_id(politician_id)

        user.name                  = (politician['first_name'] || '').split(' ').map(&:capitalize).join(' ') if user.name.blank?
        user.lastname              = (politician['last_name'] || '').split(' ').map(&:capitalize).join(' ')  if user.lastname.blank?
        user.lastname              = ' '                                                                     if user.lastname.blank?
        user.contact_email         =  politician['email'].try(:first)                                        if user.contact_email.blank?
        user.province              = (politician['address'][3] || '').split(' ').map(&:capitalize).join(' ') if user.province.blank?
        user.city                  = (politician['address'][2] || '').split(' ').map(&:capitalize).join(' ') if user.city.blank?
        user.role                  = Role.politician.first                                                   if user.role.blank?
        user.areas                 = [area_model]
        if user.new_record?
          user.email                 = "#{user.fullname.underscore}@ej-gv.es"
          user.password              = 'virekia'
          user.password_confirmation = 'virekia'
        end

        title_name = politician['works_for'].first.first.try(:capitalize)
        if user.title.present?
          user.title.update_attribute('translated_name', (user.title.translated_name || {}).merge({"#{lang}" => title_name}))
        else
          user.title = Title.create(:translated_name => {"#{lang}" => title_name}, :name => title_name)
        end

        user.facebook_url          = politician[''].first rescue nil if user.facebook_url.blank?
        user.webs                  = (politician['web'] || []).join('|')     if user.webs.blank?
        user.last_import           = Time.at(politician['update_date'])
        user.profile_picture       = Image.create(:remote_image_url => "http://www2.irekia.euskadi.net/#{politician['image']}") if politician['image'] && user.profile_picture.blank?
        user.skip_mailing          = true

        if File.exists?(Rails.root.join('db', 'seeds', 'support', 'images', "#{user.slug}.jpg"))
          user.profile_picture.destroy
          user.profile_picture = Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', "#{user.slug}.jpg")))
        end
        user.save!

        unless AreaUser.exists?(:user_id => user.id, :area_id => area_model.id)
          user.areas_users.create(:area_id => area_model.id, :display_order => (area_model.areas_users.maximum('display_order') || 0) + 1)
        end

      rescue Exception => ex
        puts politician.inspect if politician.present?
        puts ex
        puts ex.backtrace
      end
    end

    def self.get_json(url, server_options = {}, items_key = nil)
      if server_options.present? && server_options.is_a?(String)
        items_key      = server_options
        server_options = {}
      end

      json_data = nil
      page = 1

      data = JSON.parse(open(url, server_options).read)
      json_data = items_key ? data[items_key] : data
      pagination = data['pagination'] rescue nil

      if pagination.present?
        pending_items = pagination[0]

        while pending_items > 0 do
          page += 1
          data = JSON.parse(open(url + "?page=#{page}", server_options).read)
          json_data += (items_key ? data[items_key] : data)
          pagination = data['pagination']

          pending_items = pending_items - (pagination[1] * page)
        end
      end

      json_data
    end

  end

end

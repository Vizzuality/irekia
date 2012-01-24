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


      %w(en eu es).each do |lang|

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
            news.news_data.source_url = news_item.url rescue nil
            news.news_data.iframe_url = news_item.multimedia_iframe_src rescue nil
            news.tags                 = news_item.categories.reject{|t| t.match(/^_/) || t.match(/::/)}.join(',')
            news.moderated            = true

            news.areas = []
            area_name = news_item.organization.title == 'Presidencia' ? 'Lehendakaritza' : news_item.organization.title if news_item.organization.present? && news_item.organization.title.present?
            news.areas << Area.where("name_#{lang} like ? OR name like ?", "%#{area_name}%", "%#{area_name}%").first rescue puts "Invalid área name: #{area_name}" if area_name.present?
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

      events_ics_url = 'http://www.irekia.euskadi.net/es/events/myfeed.ics?dept_label=all'
      event_detail_url = lambda{|event_id| "http://www.irekia.euskadi.net/es/events/#{event_id}.xml"}

      open(events_ics_url) do |ical_file|
        puts '=> parsing calendar file'
        calendar = RiCal.parse_string(ical_file.read).first rescue nil
        events = calendar.events
        puts "=> loading #{events.count} events found"
        events.each do |event_data|
          event_uid = event_data.uid[/uid_(\d*)_irekia_euskadi_net/, 1]
          event_data_detail = Nokogiri::Slop(open(event_detail_url.call(event_uid)).read)

          begin
            event_data_model = EventData.find_by_external_id(event_uid) || EventData.new

            event_data_model.title       = event_data.summary
            event_data_model.body        = event_data.description
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

            event.areas = []
            event.users = []
            area_name = event_data_detail.event.organismo.title.text.strip == 'Presidencia' ? 'Lehendakaritza' : event_data_detail.event.organismo.title.text.strip if event_data_detail.event.organismo.title.text.strip.present? rescue nil
            event.areas << Area.where("name like ? OR name_es like ? OR name_eu like ? OR name_en like ?", *(["%#{area_name}%"] * 4)).first rescue puts "Invalid área name: #{area_name}"
            event_data_detail.event.tags.search('tag').each do |tag|
              event.areas << Area.find_by_name(tag.text.strip) rescue nil
              event.users << User.where('name || ' ' || lastname = ?', tag.text.strip).first rescue nil
            end
            event_data_detail.event.asisten.text.split(',').each do |politician|
              event.users << User.where('name || ' ' || lastname like ? AND id not in (?)', "%#{category}%", event.users_ids).first rescue nil
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
      politician_detail_url = lambda{ |language, id| "#{server}/#{language}/people/#{id}.json" }

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
              area_name = area['name'].gsub(/^Departamento de /, '').gsub(/ saila$/, '')

              Area.where(:external_id => area_id).each do |area_model|
                if area_model.lehendakaritza?
                  area_model.send("name_#{lang}=", 'Lehendakaritza')
                else
                  area_model.send("name_#{lang}=", area_name)
                end
                area_model.set_friendly_id(area_name, lang.to_sym)
                area_model.save!
              end

              puts "=> getting politicians data for #{area_id} - #{area_name}"

              politicians_ids = area_detail['people'].map(&:first)

              politicians_ids.each do |politician_id|
                politician = get_json(politician_detail_url.call(lang, politician_id), 'person')

                begin
                  user = User.find_or_initialize_by_external_id(politician_id)

                  user.name                  = (politician['first_name'] || '').split(' ').map(&:capitalize).join(' ')
                  user.lastname              = (politician['last_name'] || '').split(' ').map(&:capitalize).join(' ')
                  user.contact_email         =  politician['email'].try(:first)
                  user.province              = (politician['address'][3] || '').split(' ').map(&:capitalize).join(' ')
                  user.city                  = (politician['address'][2] || '').split(' ').map(&:capitalize).join(' ')
                  user.role                  = Role.politician.first
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

                  user.facebook_username     = politician[''].first.delete('http://facebook.com/') rescue nil
                  user.areas                 = Area.where(:external_id => area['id'])
                  user.last_import           = Time.at(politician['update_date'])
                  user.profile_picture       = Image.create(:remote_image_url => "http://www2.irekia.euskadi.net/#{politician['image']}") if politician['image']
                  user.skip_welcome          = true
                  user.save!

                  if File.exists?(Rails.root.join('db', 'seeds', 'support', 'images', "#{user.slug}.jpg"))
                    user.profile_picture.destroy
                    user.profile_picture = Image.create(:image => File.open(Rails.root.join('db', 'seeds', 'support', 'images', "#{user.slug}.jpg")))
                    user.save!
                  end
                rescue Exception => ex
                  puts politician.inspect
                  puts ex
                  puts ex.backtrace
                end
              end
            end
          end
        rescue Exception => ex
          puts ex
          puts ex.backtrace
        end
      end

      puts '=> import complete!'
    end

    #id;Email;Contraseña;Salt;Twitter screen_name;Twitter atoken;Twitter asecret;Facebook ID;Nombre;Apellidos;Tipo;Departamento;Lugar;Código postal;Provincia;Ciudad
    def self.import_users
      puts ''
      puts 'Importing users'
      puts '==============='
      require 'csv'

      CSV.foreach(Rails.root.join('db/seeds/support/datos_usuarios.csv'), :col_sep => ';', :headers => :first_row) do |row|

        begin

          user = User.new
          user.email                      = row['Email']
          user.encrypted_password         = row['Password']
          user.salt                       = row['Salt']
          user.twitter_username           = row['Twitter screen_name'] if row['Twitter screen_name'].present?
          user.twitter_oauth_token        = row['Twitter atoken'] if row['Twitter atoken'].present?
          user.twitter_oauth_token_secret = row['Twitter asecret'] if row['Twitter asecret'].present?
          user.facebook_oauth_token       = row['Facebook ID'] if row['Facebook ID'].present?
          user.name                       = row['Nombre']
          user.lastname                   = row['Apellidos']
          user.postal_code                = row['Codigo postal']
          user.province                   = row['Provincia']
          user.city                       = row['Ciudad']
          user.external_id                = row['id']
          user.skip_welcome               = true

          user.save(false)

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

        rescue Exception => ex
          puts ex
          puts ex.backtrace
        end

      end

    end

    private

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

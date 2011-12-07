module Irekia
    class Importer

      def self.get_news_from_rss
        puts 'Importing news from Irekia'
        puts '============================'

        last_news_date = News.maximum('published_at')

        puts '=> reading and parsing the rss feed'
        news_feed_url        = 'http://www.irekia.euskadi.net/es/news/news.rss'
        news_feed_url        = news_feed_url + "?since=#{last_news_date.strftime('%Y%m%d')}" if last_news_date.present?
        news_photos_feed_url = lambda{|news_id| "http://www.irekia.euskadi.net/api/photos/#{news_id}"}

        feed = Feedzirra::Feed.fetch_and_parse(news_feed_url)
        news_entries = feed.entries
        news_entries = feed.entries.select{|news| news.published > last_news_date} if last_news_date.present?

        puts "=> loading #{news_entries.count} news found"
        news_entries.each do |news_item|
          begin
            news_images    = get_json(news_photos_feed_url.call(news_item.entry_id))
            news_image_url = news_images.first['original'] if news_images.present?

            news = News.new
            news.news_data = NewsData.create(:title      => news_item.title.sanitize,
                                             :body          => news_item.summary.sanitize,
                                             :source_url    => news_item.url)
            news.external_id = news_item.entry_id
            news.moderated = true
            news.news_data.image = Image.new({
              :remote_image_url => news_image_url
            }) if news_image_url.present?
            news.areas << Area.all.sample
            news.users << User.politicians.sample
            news.save!
            print '.'
          rescue Exception => ex
            puts ex
            puts ex.backtrace
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

        puts 'Importing events from Irekia'
        puts '============================'

        puts '=> reading feeds'
        events_ics_url = 'http://www.irekia.euskadi.net/es/events/myfeed.ics?dept_label=all'
        open(events_ics_url) do |ical_file|
          puts '=> parsing calendar file'
          calendar = RiCal.parse_string(ical_file.read).first rescue nil
          events = calendar.events
          puts "=> loading #{events.count} events found"
          events.each do |event_data|
            begin
              event = Event.new
              event.event_data = EventData.new(:title      => event_data.summary,
                                               :body       => event_data.description,
                                               :event_date => event_data.dtstart,
                                               :duration   => event_data.dtend - event_data.dtstart)

              event.location  = event_data.location
              event.moderated = true
              event.users << User.politicians.sample
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
        puts "Importing politicians' data from communication guide"
        puts '===================================================='
        require 'open-uri'

        communication_guide_server = {
          :production => {:url => 'http://www2.irekia.euskadi.net'},
          :others     => {
            :url      => 'http://gc.efaber.net',
            :options  => {
              :http_basic_authentication => ['direcciones', 'helbideak']
            }
          }
        }
        languages             = %w(es eu)
        server                = communication_guide_server[Rails.env.production?? :production : :others]
        server_options        = server[:options] || {}
        categories_url        = lambda{ |language| "#{server[:url]}/#{language}/categories.json" }
        areas_url             = lambda{ |language, id| "#{server[:url]}/#{language}/categories/#{id}.json" }
        area_detail_url       = lambda{ |language, id| "#{server[:url]}/#{language}/entities/#{id}.json" }
        politician_detail_url = lambda{ |language, id| "#{server[:url]}/#{language}/people/#{id}.json" }

        languages.each do |lang|
          puts "=> getting data for #{lang} language"
          puts "=> getting all categories"
          categories = get_json(categories_url.call(lang), server_options)['categories']

          basque_government = categories.select{|c| ['gobierno vasco', 'eusko jaurlaritza'].include?((c['name'] || '').downcase.strip)}.first
          if basque_government.present?

            puts '=> getting all government areas'
            areas = get_json(areas_url.call(lang, basque_government['id']), server_options)['categories']

            areas.each do |area|
              area_id = area['id']
              area_detail = get_json(area_detail_url.call(lang, area_id), server_options)

              Area.where(:long_name => area['name']).each do |area|
                area.external_id = area_id
                area.save!
              end

              puts "=> getting politicians data for #{area['name']}"

              politicians_ids = area_detail['people'].map(&:first)

              politicians_ids.each do |politician_id|
                politician = get_json(politician_detail_url.call(lang, politician_id), server_options)['person']

                begin
                  user = User.find_or_initialize_by_external_id(politician_id)

                  user.name                  = (politician['first_name'] || '').split(' ').map(&:capitalize).join(' ')
                  user.lastname              = (politician['last_name'] || '').split(' ').map(&:capitalize).join(' ')
                  user.email                 =  politician['email'].try(:first).present?? politician['email'].try(:first) : "#{politician_id}@ej-gv.es"
                  user.password              = 'virekia'
                  user.password_confirmation = 'virekia'
                  user.province              = (politician['address'][3] || '').split(' ').map(&:capitalize).join(' ')
                  user.city                  = (politician['address'][2] || '').split(' ').map(&:capitalize).join(' ')
                  user.role                  = Role.politician.first

                  title_name = politician['works_for'].first.first.try(:capitalize)
                  if user.title.present?
                    user.title.update_attribute('translated_name', (user.title.translated_name || {}).merge({"#{lang}" => title_name}))
                  else
                    user.title = Title.create(:translated_name => {"#{lang}" => title_name}, :name => title_name)
                  end

                  user.facebook_username     = politician[''].first.delete('http://facebook.com/') rescue nil
                  user.areas                 = Area.where(:external_id => area['id'])
                  user.last_import           = Time.at(politician['update_date'])
                  # user.profile_pictures << params[:profile_picture] if params[:profile_picture]
                  user.save!
                rescue Exception => ex
                  puts politician.inspect
                  puts ex
                  puts ex.backtrace
                end
              end
            end
          end
        end

        puts '=> import complete!'
      end

      private

      def self.get_json(url, server_options = {})
        JSON.parse(open(url, server_options).read)
      end

    end

end

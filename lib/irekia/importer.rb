module Irekia
		class Importer

			def self.get_news_from_rss
				news_feed_url = 'http://www.irekia.euskadi.net/es/news.rss'
				feed = Feedzirra::Feed.fetch_and_parse(news_feed_url)
				last_news_date = News.maximum('published_at')

				news_entries = feed.entries
				news_entries = feed.entries.select{|news| news.published > last_news_date} if last_news_date.present?

				news_entries.each do |news_item|
					begin
						news = News.new
						news.news_data = NewsData.new(:title      => news_item.title.sanitize,
																					:body       => news_item.summary.sanitize,
																				  :source_url => news_item.url)
						news.areas << Area.find(7)
						news.moderated = true
						news.save!
					rescue Exception => ex
						puts ex
						puts ex.backtrace
					end
				end
			rescue Exception => ex
				puts ex
				puts ex.backtrace
			end

		end
end

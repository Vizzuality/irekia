#encoding: UTF-8

Delorean.time_travel_to '08/03/2011'

load Rails.root.join('db/seeds/data/factories.rb')
load Rails.root.join('db/seeds/data/areas.rb')
load Rails.root.join('db/seeds/data/users.rb')
load Rails.root.join('db/seeds/data/proposals.rb')
load Rails.root.join('db/seeds/data/votes.rb')
load Rails.root.join('db/seeds/data/arguments.rb')
load Rails.root.join('db/seeds/data/questions.rb')
load Rails.root.join('db/seeds/data/answers.rb')
load Rails.root.join('db/seeds/data/news.rb')
load Rails.root.join('db/seeds/data/events.rb')
load Rails.root.join('db/seeds/data/photos.rb')
load Rails.root.join('db/seeds/data/tweets.rb')

@question.update_attribute('published_at', Time.now)
@news.update_attribute('published_at', Time.now)
@answer.update_attribute('published_at', Time.now)

Delorean.back_to_the_present


#encoding: UTF-8

puts ''
puts "- Loading testing data"

load Rails.root.join('db/seeds/data/factories.rb')
load Rails.root.join('db/seeds/data/users.rb')
load Rails.root.join('db/seeds/data/proposals.rb')
load Rails.root.join('db/seeds/data/votes.rb')
load Rails.root.join('db/seeds/data/arguments.rb')
load Rails.root.join('db/seeds/data/questions.rb')
load Rails.root.join('db/seeds/data/news.rb')
load Rails.root.join('db/seeds/data/events.rb')
load Rails.root.join('db/seeds/data/photos.rb')
load Rails.root.join('db/seeds/data/status_messages.rb')
load Rails.root.join('db/seeds/data/tweets.rb')


# Validates all contents and participation
Content.validate_all_not_moderated
Participation.validate_all_not_moderated

# Orders all test data randomly
Content.find_each do |content|
  content.published_at =  Time.current.advance(:days => -rand(5), :hours => -rand(24), :minutes => -rand(60))
  content.save!
end
Participation.find_each do |participation|
  participation.published_at =  Time.current.advance(:days => -rand(5), :hours => -rand(24), :minutes => -rand(60))
  participation.save!
end

puts ''

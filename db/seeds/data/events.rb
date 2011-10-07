#encoding: UTF-8

puts ''.green
puts 'Creating events...'.green
puts '=================='.green

this_week = Time.current.beginning_of_week

100.times do
  create_event :user => @virginia,
               :date => this_week.advance(:days => rand(21), :hours => rand(24))
end

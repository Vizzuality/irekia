#encoding: UTF-8
%w(master_tables).each do |seed|
  puts ''
  require Rails.root.join('db', 'seeds', seed)
end

puts ''
puts '============================='
puts "Loading #{Rails.env} test data"
Dir[Rails.root.join('db', 'seeds', Rails.env, '*')].each do |seed_script|
  require seed_script
end
puts ''
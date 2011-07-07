#encoding: UTF-8
%w(master_tables).each do |seed|
  puts ''
  require Rails.root.join('db', 'seeds', seed)
end

if Rails.env.development? || Rails.env.staging?
  puts ''
  puts '============================='
  puts "Loading test data"
  require Rails.root.join('db', 'seeds', 'test_data', 'test_data')
  puts ''
end

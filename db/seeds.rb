#encoding: UTF-8
%w(master_tables).each do |seed|
  puts '- Loading seed data:'.red
  require Rails.root.join('db', 'seeds', seed)
end

if Rails.env.development? || Rails.env.test? || Rails.env.staging?
  puts ''
  puts '- Loading test data'.red
  require Rails.root.join('db', 'seeds', 'test_data', 'test_data')
end

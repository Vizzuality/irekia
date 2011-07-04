#encoding: UTF-8
%w(master_tables).each do |seed|
  puts ''
  require Rails.root.join('db', 'seeds', seed)
end

if Rails.env.development?
  puts ''
  puts '============================='
  puts 'Loading development test data'
  %w(areas users contents).each do |seed|
    puts ''
    require Rails.root.join('db', 'seeds', 'development', seed)
  end
  puts ''
end
Capybara.server_port = 3001
Capybara.app_host    = "http://www.example.com:#{Capybara.server_port}"
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => 'default')
end


module Faker
  def random_string(length = 50)
    (0...length).map{ ('a'..'z').to_a[rand(26)] }.join
  end
end
RSpec.configure {|config| config.include Faker}
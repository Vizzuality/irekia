#encoding: UTF-8

module Factories

  def init_area_data
    silence_stream(STDOUT) do
      load Rails.root.join('db', 'seeds.rb')
    end

    Content.validate_all_not_moderated
    Participation.validate_all_not_moderated

    Area.where(:name => 'Educación, Universidades e Investigación').first
  end

end
RSpec.configure {|config| config.include Factories}
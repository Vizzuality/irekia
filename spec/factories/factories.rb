#encoding: UTF-8

module Factories

  def get_area_data
    validate_all_not_moderated

    Area.where(:name => 'Educación, Universidades e Investigación').first
  end

  def get_politic_data
    validate_all_not_moderated

    User.where(:name => 'Virginia Uriarte Rodríguez').first
  end

  def validate_all_not_moderated
    Content.validate_all_not_moderated
    Participation.validate_all_not_moderated
  end

end
RSpec.configure {|config| config.include Factories}
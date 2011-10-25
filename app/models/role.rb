#encoding: UTF-8

class Role < ActiveRecord::Base
  has_many :users

  def self.politician
    where(:name => 'Politician')
  end

  def self.administrator
    where(:name => 'Administrator')
  end

  def self.citizen
    where(:name => 'Citizen')
  end

  def politician?
    self.name_i18n_key.eql?('politician')
  end

  def administrator?
    self.name_i18n_key.eql?('administrator')
  end

  def citizen?
    self.name_i18n_key.eql?('citizen')
  end

end

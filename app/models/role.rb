#encoding: UTF-8

class Role < ActiveRecord::Base
  has_many :users

  scope :politician, where(:name => 'Politician')
  scope :administrator, where(:name => 'Administrator')
  scope :citizen, where(:name => 'Citizen')

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

#encoding: UTF-8

class Role < ActiveRecord::Base
  has_many :users

  scope :politician, where(:name => 'Politician')
  scope :administrator, where(:name => 'Administrator')
  scope :citizen, where(:name => 'Citizen')

  def politician?
    self.name.eql?('Politician')
  end

  def administrator?
    self.name.eql?('Administrator')
  end

  def citizen?
    self.name.eql?('Citizen')
  end

end

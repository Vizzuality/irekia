#encoding: UTF-8

class Role < ActiveRecord::Base
  has_many :users

  scope :politic, where(:name => 'Politic')
  scope :administrator, where(:name => 'Administrator')
  scope :citizen, where(:name => 'Citizen')

  def politic?
    self.name.eql?('Politic')
  end

  def administrator?
    self.name.eql?('Administrator')
  end

  def citizen?
    self.name.eql?('Citizen')
  end

end

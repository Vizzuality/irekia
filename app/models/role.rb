#encoding: UTF-8

class Role < ActiveRecord::Base
  has_many :users

  scope :politic, where(:name => 'Político')
  scope :administrator, where(:name => 'Administrador')
  scope :citizen, where(:name => 'Ciudadano')

  def politic?
    self.name.eql?('Político')
  end

  def administrator?
    self.name.eql?('Administrador')
  end

  def citizen?
    self.name.eql?('Ciudadano')
  end

end

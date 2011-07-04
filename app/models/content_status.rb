class ContentStatus < ActiveRecord::Base
  has_many :contents

  def self.open_proposal
    scoped.where(:name => 'open').first
  end

  def self.closed_proposal
    scoped.where(:name => 'closed').first
  end

  def self.in_favor
    scoped.where(:name => 'in_favor').first
  end

  def self.against
    scoped.where(:name => 'against').first
  end
end

class ContentStatus < ActiveRecord::Base
  translates :name

  has_many :contents

  def self.open_proposal
    scoped.where(:name => 'open').first
  end

  def self.closed_proposal
    scoped.where(:name => 'closed').first
  end
end

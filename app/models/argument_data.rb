class ArgumentData < ActiveRecord::Base
  belongs_to :argument,
             :foreign_key => :argument_id

  delegate :publish, :to => :argument

  def against
    !in_favor
  end

end

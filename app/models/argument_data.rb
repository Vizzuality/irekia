class ArgumentData < ActiveRecord::Base
  belongs_to :argument,
             :foreign_key => :argument_id

  def against
    !in_favor
  end
end

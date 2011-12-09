class ArgumentData < ActiveRecord::Base
  belongs_to :argument,
             :foreign_key => :argument_id

  def against
    !in_favor
  end

  def publish
    argument.publish if argument.present?
  end
end

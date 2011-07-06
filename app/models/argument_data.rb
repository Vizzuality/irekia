class ArgumentData < ActiveRecord::Base
  belongs_to :argument,
             :foreign_key => :argument_id

end

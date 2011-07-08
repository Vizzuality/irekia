module StringExt
  module ClassMethods
    def random(length = 50)
      (0...length).map{ ('a'..'z').to_a[rand(26)] }.join
    end
  end

  module InstanceMethods
    def sanitize_sql!
      self.gsub(/\\/, '\&\&').gsub(/'/, "''")
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

class String; include StringExt; end
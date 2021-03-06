module StringExt
  module ClassMethods
    def random(length = 50)
      (0...length).map{ ('a'..'z').to_a[rand(26)] }.join
    end

    def lorem
      'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
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

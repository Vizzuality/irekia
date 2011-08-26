module ObjectExt
  module ClassMethods
  end

  module InstanceMethods
    def hashes2ostruct
      return case self
      when Hash
        object = self.clone
        object.each do |key, value|
          object[key] = value.hashes2ostruct
        end
        OpenStruct.new(object)
      when Array
        object = self.clone
        object.map! { |i| i.hashes2ostruct }
      else
        self
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

class Object; include ObjectExt; end
module ActionView
  module Helpers
    class FormBuilder

      def submit_with_login(value=nil, options={})
        current_user = instance_variable_get('@template').instance_variable_get('@current_user')
        options[:class] = "floating-login #{options[:class]}" unless current_user
        submit(value, options)
      end

    end
  end
end

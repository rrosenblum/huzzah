module Huzzah
  module Cucumber
    module DSL

      def as(role_name)
        role = instance_variable_get "@#{role_name}"
        fail Huzzah::RoleNotDefinedError unless role
        fail Huzzah::NotARoleError unless role.is_a? Huzzah::Role
        role
      end

      def close_browsers
        instance_variables.each do |instance_variable|
          instance = instance_variable_get instance_variable
          if instance.is_a? Huzzah::Role
            if instance.browser.exists?
              instance.browser.close
            end
          end
        end
      end

    end
  end
end
module Huzzah
  module Cucumber
    module DSL

      def as(role_name)
        role = instance_variable_get("@#{role_name}")
        fail Huzzah::RoleNotDefinedError unless role
        fail Huzzah::NotARoleError unless role.is_a? Huzzah::Role
        role
      end

      def close_browsers
        ObjectSpace.each_object(Huzzah::Role).each do |role|
          role.browser.close rescue NoMethodError
        end
      end

    end
  end
end
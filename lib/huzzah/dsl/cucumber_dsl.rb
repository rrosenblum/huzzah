module Huzzah
  module Cucumber
    module DSL
      ##
      # Dynamically switch the active role. Intended to be used
      # when the role name is passed as an argument to a Cucumber
      # step definition.
      #
      # Example:
      #   as(admin).google.home_page.search_for('Huzzah')
      #
      def as(role_name)
        role = instance_variable_get("@#{role_name}")
        fail Huzzah::RoleNotDefinedError unless role
        fail Huzzah::NotARoleError unless role.is_a?(Huzzah::Role)
        role
      end

      ##
      # Closes all open browsers for all instantiated roles. Intended
      # to be used in a Cucumber hook.
      #
      def close_browsers
        ObjectSpace.each_object(Huzzah::Role).each do |role|
          role.browser.close rescue NoMethodError
        end
      end
    end
  end
end

require 'pry'
require 'huzzah'

Huzzah.config_path = __dir__
Huzzah.environment = 'dev'

some_role = Huzzah::Role.new(:some_role)
some_other_role = Huzzah::Role.new(:blah)

binding.pry
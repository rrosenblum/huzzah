# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'huzzah/version'

Gem::Specification.new do |spec|
  spec.name = 'huzzah'
  spec.version = Huzzah::VERSION
  spec.authors = ['Lance Howard', 'Umair Chagani', 'Wallace Hardwood',
                  'Jarod Adair', 'Leonard Fingerman']
  spec.email = ['lance.howard@manheim.com', 'umair.chagani@manheim.com',
                'wallace.harwood@manheim.com', 'jarod.adair@manheim.com',
                'leonard.fingerman@manheim.com']
  spec.summary = 'Huzzah!'
  spec.description = 'Role-based Testing Framework'
  spec.homepage = 'http://github.com/Manheim/huzzah'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency('rspec', '~> 3.8.0')
  spec.add_development_dependency('pry', '~> 0.10.1')
  spec.add_development_dependency('simplecov', '~>  0.10.0')
  spec.add_development_dependency('rake', '~> 10.4.0')
  spec.add_development_dependency('watir', '~> 6.16.0')

  spec.add_runtime_dependency('activesupport', '> 4.2.0', '< 6.0.0')

  spec.post_install_message = 'Huzzah!'
end

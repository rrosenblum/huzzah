# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'huzzah/version'

Gem::Specification.new do |spec|
  spec.name = "huzzah"
  spec.version = Huzzah::VERSION
  spec.authors = ["Lance Howard"]
  spec.email = ["lance.howard@manheim.com"]
  spec.summary = "Huzzah!"
  spec.description = "Application Modeling Framework for Test Automation"
  spec.homepage = "http://github.com/Manheim/huzzah"
  spec.license = "MIT"

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency('bundler', '~> 1.5')
  spec.add_development_dependency('rspec', '~> 3.2.0')
  spec.add_development_dependency('pry', '~> 0.10.1')
  spec.add_development_dependency('simplecov', '~>  0.10.0')
  spec.add_development_dependency('rake', '~> 10.4.0')

  spec.add_runtime_dependency('watir-webdriver', '0.6.10')
  spec.add_runtime_dependency('appium_lib', '7.0.0')
  spec.add_runtime_dependency('activesupport', '4.2.2')
  spec.post_install_message = "Huzzah!"

end

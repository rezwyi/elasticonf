require File.expand_path('../lib/elasticonf/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'elasticonf'
  s.summary = 'Powerfull and flexible application config solution worked in any ruby program'
  s.description = s.summary

  s.version  = Elasticonf::VERSION
  s.platform  = Gem::Platform::RUBY

  s.authors = ['Sergey Rezvanov']
  s.email = ['sergey@rezvanov.info']
  s.homepage = 'https://github.com/rezwyi/elasticonf'

  s.licenses = ['MIT']

  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.0'

  s.add_dependency 'hashie', '~> 3.0'
  s.add_dependency 'semantic', '> 0'

  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'yard', '~> 0.8'
end

require File.expand_path('../lib/elasticonf/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'elasticonf'
  s.summary = 'Powerfull and flexible application config solution worked in any ruby program'
  s.description = s.summary

  s.version  = ElastiConf::VERSION
  s.platform  = Gem::Platform::RUBY
  
  s.authors = ['Sergey Rezvanov']
  s.email = ['sergey@rezvanov.info']
  s.homepage = 'https://github.com/rezwyi/elasticonf'

  s.licenses = ['MIT']

  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'hashie'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
end
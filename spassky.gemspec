# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spassky/version"

Gem::Specification.new do |s|
  s.name        = "spassky"
  s.version     = Spassky::VERSION
  s.authors     = ["Joshua Chisholm", "Andrew Vos", "Adrian Lewis"]
  s.email       = ["andrew.vos@gmail.com"]
  s.homepage    = "http://github.com/BBC/spassky"
  s.summary     = %q{}
  s.description = %q{}

  s.rubyforge_project = "spassky"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rest-client'
  s.add_dependency 'json'
  s.add_dependency 'sinatra'
  s.add_dependency 'rainbow'
  s.add_dependency 'wurfl-lite'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'fakefs'
end

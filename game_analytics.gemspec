# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'game_analytics/version'

Gem::Specification.new do |spec|
  spec.name          = "game_analytics"
  spec.version       = GameAnalytics::VERSION
  spec.authors       = ["wlipa"]
  spec.email         = ["dojo@masterleep.com"]
  spec.description   = %q{Lightweight and non-disruptive interface to save metrics data to gameanalytics.com}
  spec.summary       = %q{saves metrics data to gameanalytics.com}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('httpclient')
  spec.add_dependency('rails')

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

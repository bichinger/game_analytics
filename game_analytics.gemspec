# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'game_analytics/version'

Gem::Specification.new do |spec|
  spec.name          = 'game_analytics'
  spec.version       = GameAnalytics::VERSION
  spec.description   = %q{Lightweight and non-disruptive interface to save metrics data to gameanalytics.com using its REST API}
  spec.summary       = %q{Interface to the REST API of the metrics collection service gameanalytics.com}
  spec.homepage      = 'https://github.com/bichinger/game_analytics'
  spec.license       = 'MIT'
  spec.authors       = ['wlipa','gr8bit']
  spec.email         = ['niklas@bichinger.de]

  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency('httpclient')
  spec.add_dependency('rails')

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

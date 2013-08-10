# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'story_fight/version'

Gem::Specification.new do |spec|
  spec.name          = "story_fight"
  spec.version       = StoryFight::VERSION
  spec.authors       = ["Noah Gibbs"]
  spec.email         = ["noah_gibbs@yahoo.com"]
  spec.description   = %q{Stories fight, one or more win.}
  spec.summary       = %q{Stories fight, one or more win.}
  spec.homepage      = "https://github.com/noahgibbs/story_fight"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"

  spec.add_runtime_dependency "multi_json"
  spec.add_runtime_dependency "trollop"
end

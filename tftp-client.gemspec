# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tftp/client/version'

Gem::Specification.new do |spec|
  spec.name          = "tftp-client"
  spec.version       = Tftp::Client::VERSION
  spec.authors       = ["Stas Kobzar"]
  spec.email         = ["stas@modulis.ca"]
  spec.description   = %q{TFTP client}
  spec.summary       = %q{TFTP client ruby implementation}
  spec.homepage      = "https://github.com/staskobzar/tftp-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('rake', '~> 0.9.2')
  spec.add_dependency('methadone', '~> 1.3.0')
  spec.add_development_dependency('rspec')
end

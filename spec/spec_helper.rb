require 'simplecov'
require 'coveralls'
Coveralls.wear!
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter "spec/"
end

require 'fakefs/spec_helpers'
require 'tftp/client'
require 'pp'

def testfile_path
  File.expand_path("lorem.txt","spec/fixtures")
end


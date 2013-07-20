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
require 'tftp/client'
require 'pp'

def testfile_path
  File.expand_path("lorem.txt","fixtures")
end

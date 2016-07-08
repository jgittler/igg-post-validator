require "minitest"
require_relative "../lib/app.rb"
require_relative "./csv_parser_test.rb"
require_relative "./share_validator_test.rb"
require_relative "./backer_test.rb"

system "rake db:test:up"

MiniTest.autorun

# system "rake db:test:clean"

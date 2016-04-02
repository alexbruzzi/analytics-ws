require 'rubygems'
require 'bundler'
require 'octocore'


Bundler.require

require_relative('analyticsws')

Octo.connect_with_config_file(File.join(Dir.pwd, 'config', 'config.yml'))

run AnalyticsWS

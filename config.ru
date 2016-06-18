require 'rubygems'
require 'bundler'
require 'octocore'


Bundler.require

require_relative('analyticsws')

Octo.connect_with(File.join(Dir.pwd, 'config'))

run AnalyticsWS

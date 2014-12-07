require 'grape'
require 'redis'
require 'json'
require 'yaml'

Dir[File.dirname(__FILE__) + "/app/*/*.rb"].each {|file| require file }
require File.dirname(__FILE__) + "/app/core.rb"

$logger = Logger.new('logs/debug.log')

$redis = Redis.new

run RabbitHouse::Core

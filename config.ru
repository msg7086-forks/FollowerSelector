require 'grape'
require 'redis'
require 'json'
require 'yaml'
require 'securerandom'

Dir[File.dirname(__FILE__) + "/app/*/*.rb"].each {|file| require file }
require File.dirname(__FILE__) + "/app/core.rb"

$logger = Logger.new('logs/debug.log')

$redis = Redis.new
$perm = {}

run RabbitHouse::Core

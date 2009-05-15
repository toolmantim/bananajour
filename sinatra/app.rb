require 'rubygems'
require "#{File.dirname(__FILE__)}/../lib/bananajour"

require 'sinatra'
require 'digest/md5'

disable :logging

load "#{File.dirname(__FILE__)}/lib/date_helpers.rb"
helpers DateHelpers

get "/" do
  @repositories = Bananajour.repositories
  @network_repositories = Bananajour.network_repositories
  haml :home
end

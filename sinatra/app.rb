require 'rubygems'
require "#{File.dirname(__FILE__)}/../lib/codezfeeder"

require 'sinatra'

get "/" do
  haml :home
end

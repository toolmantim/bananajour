require 'rubygems'
require "#{File.dirname(__FILE__)}/../lib/bananajour"

require 'sinatra'
require 'digest/md5'

disable :logging

load "#{File.dirname(__FILE__)}/lib/date_helpers.rb"
helpers DateHelpers

helpers do
  def admin?
    request.env["REMOTE_ADDR"] == "127.0.0.1"
  end
  def gravatar(email)
    "http://www.gravatar.com/avatar/#{Digest::md5(email.downcase)}"
  end
  def cycle
    %w{even odd}[@_cycle = ((@_cycle || -1) + 1) % 2]
  end
end

get "/" do
  @repositories = Bananajour.repositories
  haml :home
end

delete "/:repository.git" do
  if admin?
    repo = Bananajour.repository(params[:repository])
    repo.destroy!
  end
  redirect "/"
end

require 'rubygems'
require "#{File.dirname(__FILE__)}/../lib/bananajour"

require 'sinatra'
require 'ipaddr'

disable :logging

helpers do
  def admin?
    request.env["REMOTE_ADDR"] == "127.0.0.1"
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

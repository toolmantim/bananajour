require 'rubygems'
require "#{File.dirname(__FILE__)}/../lib/codezfeeder"

require 'sinatra'

disable :logging

helpers do
  def admin?
    request.env["REMOTE_ADDR"] == "127.0.0.1"
  end
end

get "/" do
  @repositories = CodezFeeder.repositories
  haml :home
end

delete "/:repository.git" do
  if admin?
    repo = CodezFeeder.repository(params[:repository])
    repo.destroy!
  end
  redirect "/"
end

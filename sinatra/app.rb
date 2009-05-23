require 'rubygems'

__DIR__ = File.dirname(__FILE__)

require "#{__DIR__}/../lib/bananajour"

Bananajour.require_gem 'rack'

# Must require 'sinatra' from this file for Sinatra's magic to pick up lots of free stuff
Bananajour::GemDependencies.for_name('sinatra').require_gem
require 'sinatra'

Bananajour.require_gem 'haml'
Bananajour.require_gem 'json'
Bananajour.require_gem 'activesupport', 'active_support/core_ext/enumerable'

set :server, 'thin' # Things go weird with anything else - let's lock it down to thin
set :haml, {:format => :html5, :attr_wrapper => '"'}
set :logging, false

load "#{__DIR__}/lib/diff_helpers.rb"
helpers DiffHelpers

require "bananajour/helpers"
helpers Bananajour::GravatarHelpers, Bananajour::DateHelpers

helpers do
  def json(body)
    content_type "application/json"
    params[:callback] ? "#{params[:callback]}(#{body});" : body
  end
  def local?
    [
      "0.0.0.0",
      "127.0.0.1",
      Socket.getaddrinfo(request.env["SERVER_NAME"], nil)[0][3]
    ].include? request.env["REMOTE_ADDR"]
  end
end

get "/" do
  @my_repositories = Bananajour.repositories
  @projects = Bananajour.all_network_repositories
  @people   = Bananajour.all_people
  haml :home
end

get "/:repository/readme" do
  @repository = Bananajour::Repository.for_name(params[:repository])
  readme_file = @repository.readme_file
  @rendered_readme = @repository.rendered_readme
  @plain_readme = readme_file.data
  haml :readme
end

get "/:repository/network-activity" do
  @repository = Bananajour::Repository.for_name(params[:repository])
  @network_repositories = Bananajour.network_repositories_similar_to(@repository)
  haml :network_activity
end

get "/:repository/:commit" do
  @repository = Bananajour::Repository.for_name(params[:repository])
  @commit = @repository.grit_repo.commit(params[:commit])
  haml :commit
end

get "/index.json" do
  json Bananajour.to_hash.to_json
end

get "/:repository.json" do
  response = Bananajour::Repository.for_name(params[:repository]).to_hash
  response["recent_commits"].map! { |c| c["committed_date_pretty"] = time_ago_in_words(Time.parse(c["committed_date"])).gsub("about ","") + " ago"; c }
  json response.to_json
end

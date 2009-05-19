require 'rubygems'

gem 'chrislloyd-fancypath', '0.5.8'
require 'fancypath'

require "#{File.dirname(__FILE__)}/../lib/bananajour"

gem 'sinatra', '0.9.1.1'
require 'sinatra'

gem 'json', '1.1.2'
require 'json'

gem 'activesupport', '2.3.2'
require 'active_support/core_ext/enumerable'

require 'md5'

disable :logging
set :environment, Bananajour.env

if Bananajour.env == "development"
  require 'rack/contrib'
  use Rack::Profiler, :printer => RubyProf::FlatPrinter
end

load "#{File.dirname(__FILE__)}/lib/date_helpers.rb"
load "#{File.dirname(__FILE__)}/lib/diff_helpers.rb"
helpers DateHelpers, DiffHelpers

helpers do
  def json(body)
    content_type "application/json"
    params[:callback] ? "#{params[:callback]}(#{body});" : body
  end
  # def view(view)
  #   haml view, :options => {:format => :html5, :attr_wrapper => '"'}
  # end
  def versioned_javascript(js)
    "/javascripts/#{js}.js?" + File.mtime(File.join(Sinatra::Application.public, "javascripts", "#{js}.js")).to_i.to_s
  end
  def local?
    [
      "0.0.0.0",
      "127.0.0.1",
      Socket.getaddrinfo(request.env["SERVER_NAME"], nil)[0][3]
    ].include? request.env["REMOTE_ADDR"]
  end
  def gravatar(email)
    "http://gravatar.com/avatar/#{MD5.md5(email)}.png"
  end
end

get "/" do
  @my_repositories = Bananajour.repositories
  @projects = Bananajour.all_network_repositories
  @people   = Bananajour.all_people
  # network_repositories = Bananajour.all_network_repositories
  # @projects = network_repositories.sort_by {|r| r.name}.group_by {|r| r.name}
  # @people   = network_repositories.sort_by {|r| r.person.name}.group_by {|r| r.person}
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

Thread.abort_on_exception = true

__DIR__ = File.dirname(__FILE__)

require "#{__DIR__}/../lib/bananajour"

Bananajour.gem 'sinatra'
require 'sinatra'

Bananajour.require_gem 'haml'
Bananajour.require_gem 'json'

Bananajour.gem 'activesupport'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/array'

require 'forwardable' # Fix for issue #8 - Thin borking on uninitialized constant Forwardable

set :server, 'thin' # Things go weird with anything else - let's lock it down to thin
set :haml, {:format => :html5, :attr_wrapper => '"'}
set :logging, false

require "#{__DIR__}/lib/browsers" # to prevent reloading
require "#{__DIR__}/lib/mock_browsers" if Sinatra::Application.development?
before do
  @bananajour_browser = BANANAJOUR_BROWSER
  @repository_browser = REPO_BROWSER
end

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
      Socket.getaddrinfo(request.env["SERVER_NAME"], nil).map {|a| a[3]}
    ].flatten.include? request.env["REMOTE_ADDR"]
  end
  def pluralize(number, singular, plural)
    "#{number} #{number == 1 ? singular : plural}"
  end
end

get "/" do
  @my_repositories     = Bananajour.repositories
  @other_repos_by_name = @repository_browser.other_repositories.group_by {|r| r.name}
  @people              = @bananajour_browser.other_bananajours
  haml :home
end

get "/:repository/readme" do
  @repository      = Bananajour::Repository.for_name(params[:repository])
  readme_file      = @repository.readme_file
  @rendered_readme = @repository.rendered_readme
  @plain_readme    = readme_file.data
  haml :readme
end

get "/:repository/:commit" do
  @repository = Bananajour::Repository.for_name(params[:repository])
  @commit     = @repository.grit_repo.commit(params[:commit])
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
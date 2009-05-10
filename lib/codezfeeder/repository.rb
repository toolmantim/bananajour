gem 'mojombo-grit'
require 'grit'

module CodezFeeder
  class Repository
    def self.for_name(name)
      new(CodezFeeder.repositories_path / (name + ".git"))
    end
    def self.for_working_path(working_path)
      new(CodezFeeder.repositories_path / (working_path.expand_path.split.last.to_s + ".git"))
    end
    def initialize(path)
      @path = Fancypath(path)
    end
    attr_reader :path
    def exists?
      path.exists?
    end
    def init!
      path.create_dir
      Dir.chdir(path) do
        `git-init --bare`
      end
    end
    def name
      dirname.sub(".git",'')
    end
    def dirname
      path.split.last.to_s
    end
    def to_s
      name
    end
    def uri
      CodezFeeder.git_uri + dirname
    end
    def grit_repo
      Grit::Repo.new(path)
    end
    def destroy!
      path.remove
    end
  end
end

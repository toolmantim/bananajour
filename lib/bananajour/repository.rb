gem 'mojombo-grit'
require 'grit'

module Bananajour
  class Repository
    def self.for_name(name)
      new(Bananajour.repositories_path.join(name + ".git"))
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
      Dir.chdir(path) { `git-init --bare` }
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
      Bananajour.git_uri + dirname
    end
    def grit_repo
      Grit::Repo.new(path)
    end
    def recent_commits
      grit_repo.commits(nil, 10)
    end
    def advertise!
      tr = DNSSD::TextRecord.new
      tr["uri"] = uri
      tr["bjour-name"] = Bananajour.config.name
      tr["bjour-uri"] = Bananajour.web_uri
      DNSSD.register(name, "_git._tcp", nil, 9418, tr) {}
    end
  end
end

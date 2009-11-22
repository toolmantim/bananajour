Bananajour.require_gem 'grit'

module Bananajour
  class Repository
    def self.for_name(name)
      new(Bananajour.repositories_path.join(name + ".git"))
    end
    def self.html_id(name)
      name.gsub(/[^A-Za-z-]+/, '').downcase
    end
    def initialize(path)
      @path = Fancypath(path)
    end
    def ==(other)
      other.respond_to?(:path) && self.path == other.path
    end
    attr_reader :path
    def exists?
      path.exists?
    end
    def init!
      path.create_dir
      Dir.chdir(path) { `git init --bare` }
    end
    def name
      dirname.sub(".git",'')
    end
    def html_id
      self.class.html_id(name)
    end
    def dirname
      path.split.last.to_s
    end
    def to_s
      name
    end
    def grit_repo
      @grit_repo ||= Grit::Repo.new(path)
    end
    def recent_commits
      @commits ||= grit_repo.commits(nil, 10)
    end
    def readme_file
      grit_repo.tree.contents.find {|c| c.name =~ /readme/i}
    end
    def rendered_readme
      case File.extname(readme_file.name)
      when /\.md/i, /\.markdown/i
        require 'rdiscount'
        RDiscount.new(readme_file.data).to_html
      when /\.textile/i
        require 'redcloth'
        RedCloth.new(readme_file.data).to_html(:textile)
      end
    rescue LoadError
      ""
    end
    def remove!
      path.rmtree
    end
    def to_hash
      heads = grit_repo.heads
      {
        "name" => name,
        "html_id" => html_id,
        "heads" => heads.map {|h| h.name},
        "recent_commits" => recent_commits.collect do |c|
          c.to_hash.merge(
            "head" => (head = heads.find {|h| h.commit == c}) && head.name,
            "gravatar" => c.author.gravatar_uri
          )
        end,
        "bananajour" => Bananajour.to_hash
      }
    end
  end
end
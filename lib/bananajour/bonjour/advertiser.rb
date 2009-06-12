class Bananajour::Bonjour::Advertiser
  def initialize
    @services = []
  end
  def go!
    register_app
    register_repos
  end
  private
    def register_app
      STDERR.puts "Registering #{Bananajour.web_uri}"
      tr = DNSSD::TextRecord.new
      tr["name"] = Bananajour.config.name
      tr["email"] = Bananajour.config.email
      tr["uri"] = Bananajour.web_uri
      tr["gravatar"] = Bananajour.gravatar
      tr["version"] = Bananajour::VERSION
      DNSSD.register("#{Bananajour.config.name}'s bananajour", "_http._tcp,_bananajour", nil, Bananajour.web_port, tr) {}
    end
    def register_repos
      loop do
        stop_old_services
        register_new_repositories
        sleep(1)
      end
    end
    def stop_old_services
      old_services.each do |old_service|
        STDERR.puts "Unregistering #{old_service.repository.uri}"
        old_service.stop
        @services.delete(old_service)
      end
    end
    def old_services
      @services.reject {|s| Bananajour.repositories.include?(s.repository)}
    end
    def register_new_repositories
      new_repositories.each do |new_repo|
        STDERR.puts "Registering #{new_repo.uri}"
        tr = DNSSD::TextRecord.new
        tr["name"] = new_repo.name
        tr["uri"] = new_repo.uri
        tr["bjour-name"] = Bananajour.config.name
        tr["bjour-email"] = Bananajour.config.email
        tr["bjour-uri"] = Bananajour.web_uri
        tr["bjour-gravatar"] = Bananajour.gravatar
        tr["bjour-version"] = Bananajour::VERSION
        service = DNSSD.register(new_repo.name, "_git._tcp,_bananajour", nil, 9418, tr) {}
        service.class.instance_eval { attr_accessor(:repository) }
        service.repository = new_repo
        @services << service
      end
    end
    def new_repositories
      Bananajour.repositories.select {|repo| !@services.any? {|s| s.repository == repo } }
    end
end
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
      tr = DNSSD::TextRecord.new
      tr["name"] = Bananajour.config.name
      tr["email"] = Bananajour.config.email
      tr["gravatar"] = Bananajour.gravatar
      tr["version"] = Bananajour::VERSION
      DNSSD.register("#{Bananajour.config.name}'s bananajour", "_http._tcp,#{Bananajour.service_id}", nil, Bananajour.web_port, tr)
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
        old_service.stop
        @services.delete(old_service)
      end
    end
    def old_services
      @services.reject {|s| Bananajour.repositories.include?(s.repository)}
    end
    def register_new_repositories
      new_repositories.each do |new_repo|
        tr = DNSSD::TextRecord.new
        tr["name"] = new_repo.name
        tr["bjour-name"] = Bananajour.config.name
        tr["bjour-email"] = Bananajour.config.email
        tr["bjour-gravatar"] = Bananajour.gravatar
        tr["bjour-version"] = Bananajour::VERSION
        service = DNSSD.register(new_repo.name, "_git._tcp,#{Bananajour.service_id}", nil, 9418, tr)
        service.class.instance_eval { attr_accessor(:repository) }
        service.repository = new_repo
        @services << service
      end
    end
    def new_repositories
      Bananajour.repositories.select {|repo| !@services.any? {|s| s.repository == repo } }
    end
end
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bananajour}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Lucas"]
  s.date = %q{2009-05-16}
  s.default_executable = %q{bananajour}
  s.description = %q{Local git repository hosting with a sexy web interface and bonjour discovery. It's like a adhoc, local, network-aware github!}
  s.email = %q{t.lucas@toolmantim.com}
  s.executables = ["bananajour"]
  s.extra_rdoc_files = ["Readme.md"]
  s.files = ["Readme.md", "Rakefile", "bin/bananajour", "lib/bananajour", "lib/bananajour/grit_extensions.rb", "lib/bananajour/repository.rb", "lib/bananajour/version.rb", "lib/bananajour.rb", "sinatra/app.rb", "sinatra/lib", "sinatra/lib/date_helpers.rb", "sinatra/public", "sinatra/public/logo.png", "sinatra/views", "sinatra/views/home.haml", "sinatra/views/layout.haml", "sinatra/views/readme.haml"]
  s.homepage = %q{http://github.com/toolmantim/bananajour}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Local git repository hosting with a sexy web interface and bonjour discovery. It's like a adhoc, local, network-aware github!}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dnssd>, ["= 0.6.0"])
      s.add_runtime_dependency(%q<rack>, ["= 0.9.1"])
      s.add_runtime_dependency(%q<chrislloyd-fancypath>, ["= 0.5.8"])
      s.add_runtime_dependency(%q<thin>, ["= 1.0.0"])
      s.add_runtime_dependency(%q<sinatra>, ["= 0.9.1.1"])
      s.add_runtime_dependency(%q<haml>, ["= 2.0.9"])
      s.add_runtime_dependency(%q<json>, ["= 1.1.2"])
      s.add_runtime_dependency(%q<mojombo-grit>, ["= 1.1.1"])
      s.add_runtime_dependency(%q<rainbow>, ["= 1.0.1"])
    else
      s.add_dependency(%q<dnssd>, ["= 0.6.0"])
      s.add_dependency(%q<rack>, ["= 0.9.1"])
      s.add_dependency(%q<chrislloyd-fancypath>, ["= 0.5.8"])
      s.add_dependency(%q<thin>, ["= 1.0.0"])
      s.add_dependency(%q<sinatra>, ["= 0.9.1.1"])
      s.add_dependency(%q<haml>, ["= 2.0.9"])
      s.add_dependency(%q<json>, ["= 1.1.2"])
      s.add_dependency(%q<mojombo-grit>, ["= 1.1.1"])
      s.add_dependency(%q<rainbow>, ["= 1.0.1"])
    end
  else
    s.add_dependency(%q<dnssd>, ["= 0.6.0"])
    s.add_dependency(%q<rack>, ["= 0.9.1"])
    s.add_dependency(%q<chrislloyd-fancypath>, ["= 0.5.8"])
    s.add_dependency(%q<thin>, ["= 1.0.0"])
    s.add_dependency(%q<sinatra>, ["= 0.9.1.1"])
    s.add_dependency(%q<haml>, ["= 2.0.9"])
    s.add_dependency(%q<json>, ["= 1.1.2"])
    s.add_dependency(%q<mojombo-grit>, ["= 1.1.1"])
    s.add_dependency(%q<rainbow>, ["= 1.0.1"])
  end
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bananajour}
  s.version = "2.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Lucas"]
  s.date = %q{2009-10-17}
  s.default_executable = %q{bananajour}
  s.description = %q{Local git repository hosting with a sexy web interface and bonjour discovery. It's like your own little adhoc, network-aware github!}
  s.email = %q{t.lucas@toolmantim.com}
  s.executables = ["bananajour"]
  s.extra_rdoc_files = ["Readme.md"]
  s.files = ["Readme.md", "Rakefile", "bin/bananajour", "lib/bananajour", "lib/bananajour/bonjour", "lib/bananajour/bonjour/advertiser.rb", "lib/bananajour/bonjour/bananajour_browser.rb", "lib/bananajour/bonjour/browser.rb", "lib/bananajour/bonjour/person.rb", "lib/bananajour/bonjour/repository.rb", "lib/bananajour/bonjour/repository_browser.rb", "lib/bananajour/bonjour.rb", "lib/bananajour/commands.rb", "lib/bananajour/gem_dependencies.rb", "lib/bananajour/grit_extensions.rb", "lib/bananajour/helpers.rb", "lib/bananajour/repository.rb", "lib/bananajour/version.rb", "lib/bananajour.rb", "sinatra/app.rb", "sinatra/lib", "sinatra/lib/browsers.rb", "sinatra/lib/diff_helpers.rb", "sinatra/lib/mock_browsers.rb", "sinatra/public", "sinatra/public/jquery-1.3.2.min.js", "sinatra/public/loader.gif", "sinatra/public/logo.png", "sinatra/public/pbjt.swf", "sinatra/public/peanut.png", "sinatra/views", "sinatra/views/commit.haml", "sinatra/views/home.haml", "sinatra/views/layout.haml", "sinatra/views/readme.haml"]
  s.has_rdoc = false
  s.homepage = %q{http://github.com/toolmantim/bananajour}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Local git repository hosting with a sexy web interface and bonjour discovery. It's like your own little adhoc, network-aware github!}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, ["= 0.9.4"])
      s.add_runtime_dependency(%q<json>, ["= 1.1.7"])
      s.add_runtime_dependency(%q<fancypath>, ["= 0.5.13"])
      s.add_runtime_dependency(%q<rainbow>, ["= 1.0.1"])
      s.add_runtime_dependency(%q<grit>, ["= 1.1.1"])
      s.add_runtime_dependency(%q<dnssd>, ["= 1.3.1"])
      s.add_runtime_dependency(%q<rack>, ["= 1.0.0"])
      s.add_runtime_dependency(%q<thin>, ["= 1.0.0"])
      s.add_runtime_dependency(%q<haml>, ["= 2.0.9"])
      s.add_runtime_dependency(%q<activesupport>, ["= 2.3.2"])
    else
      s.add_dependency(%q<sinatra>, ["= 0.9.4"])
      s.add_dependency(%q<json>, ["= 1.1.7"])
      s.add_dependency(%q<fancypath>, ["= 0.5.13"])
      s.add_dependency(%q<rainbow>, ["= 1.0.1"])
      s.add_dependency(%q<grit>, ["= 1.1.1"])
      s.add_dependency(%q<dnssd>, ["= 1.3.1"])
      s.add_dependency(%q<rack>, ["= 1.0.0"])
      s.add_dependency(%q<thin>, ["= 1.0.0"])
      s.add_dependency(%q<haml>, ["= 2.0.9"])
      s.add_dependency(%q<activesupport>, ["= 2.3.2"])
    end
  else
    s.add_dependency(%q<sinatra>, ["= 0.9.4"])
    s.add_dependency(%q<json>, ["= 1.1.7"])
    s.add_dependency(%q<fancypath>, ["= 0.5.13"])
    s.add_dependency(%q<rainbow>, ["= 1.0.1"])
    s.add_dependency(%q<grit>, ["= 1.1.1"])
    s.add_dependency(%q<dnssd>, ["= 1.3.1"])
    s.add_dependency(%q<rack>, ["= 1.0.0"])
    s.add_dependency(%q<thin>, ["= 1.0.0"])
    s.add_dependency(%q<haml>, ["= 2.0.9"])
    s.add_dependency(%q<activesupport>, ["= 2.3.2"])
  end
end

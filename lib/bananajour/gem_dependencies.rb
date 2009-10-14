module Bananajour
  # DRYs version number dependencies and provides a simple way require them
  module GemDependencies
    DEPENDENCIES = [
      %w( sinatra              0.9.2 ),
      %w( json                 1.1.7 ),
      %w( fancypath            0.5.13 ),
      %w( rainbow              1.0.1 ),
      %w( grit                 1.1.1 ),
      %w( dnssd                1.3.1 ),
      %w( rack                 1.0.0 ),
      %w( thin                 1.0.0 ),
      %w( haml                 2.0.9 ),
      %w( activesupport        2.3.2 )
    ]
    class Dependency < Struct.new(:name, :version)
      def require_gem; gem name, version end
    end
    def self.all
      DEPENDENCIES.map {|(name, version)| Dependency.new(name, version)}
    end
    def self.for_name(name)
      all.find {|d| d.name == name }
    end
  end

  def self.gem(name)
    Bananajour::GemDependencies.for_name(name).require_gem
  end
  def self.require_gem(name, lib=nil)
    self.gem(name)
    Kernel.require(lib || name)
  end
end

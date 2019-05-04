
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bitter_domain/version"

Gem::Specification.new do |spec|
  spec.name          = "bitter_domain"
  spec.version       = BitterDomain::VERSION
  spec.authors       = ["axylos"]
  spec.email         = ["="]

  spec.summary       = %q{Generate urls with a single bit flipped for researching bit squatting}
  spec.description   = %q{Get a list of available domains 1 bit away from a given domain}
  spec.homepage      = "https://github.com/Axylos/squat_logs"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/Axylos/squat_logs"
    #spec.metadata["changelog_uri"] = "none"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ['bitter_domain']
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize"
  spec.add_dependency "whois", "~> 4.0.8"
  spec.add_dependency "whois-parser", "~> 1.1.0"
  spec.add_dependency "public_suffix"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard", "~> 2.15.0"
  spec.add_development_dependency "guard-rspec", "~> 4.6.0"
  spec.add_development_dependency "byebug", "~> 11.0.1"
end

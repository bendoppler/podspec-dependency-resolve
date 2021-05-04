require_relative 'lib/pod/target/version'

Gem::Specification.new do |spec|
  spec.name          = "pod-dependency-resolve"
  spec.license       = "MIT"
  spec.version       = Pod::Dependency::Resolve::VERSION
  spec.authors       = ["Bao Do"]
  spec.email         = ["baodo789@gmail.com"]

  spec.summary       = %q{"Retrive targets' dependencies and optimize them"}
  spec.description   = %q{"Find targets' dependencies with ease in xcode workspace and propose a way to reduce dependencies"}
  spec.homepage      = "https://github.com/bendoppler/podspec-dependency-resolve.git"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'xcodeproj', '~> 1.7'
  spec.add_dependency "thor"
end

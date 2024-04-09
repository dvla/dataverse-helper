# frozen_string_literal: true

require_relative "lib/dvla/dataverse/helper/version"

Gem::Specification.new do |spec|
  spec.name = "dvla-dataverse-helper"
  spec.version = Dvla::Dataverse::Helper::VERSION
  spec.authors = ["Abdullah Janjua"]
  spec.email = ["Abdullah.Janjua@dvla.gov.uk"]

  spec.summary = "Integrate Microsoft Dataverse Web API to your project"
  spec.description = "This gem helps you integrate Microsoft Dataverse Web API to your ruby project"
  spec.homepage = "https://github.com/dvla/dataverse-helper"
  spec.required_ruby_version = ">= 2.6.0"
  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'oauth2', '~> 2.0'
  spec.add_dependency "rest-client", "~> 2.1"
  # explicit rack dependency to avoid known vulns in 2.x versions
  spec.add_dependency 'rack', "~> 3.0"

  spec.add_dependency 'colorize'
  spec.add_dependency 'config'
end

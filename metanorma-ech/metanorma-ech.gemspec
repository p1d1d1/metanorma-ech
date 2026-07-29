# frozen_string_literal: true

require_relative "lib/metanorma/ech/version"

Gem::Specification.new do |spec|
  spec.name          = "metanorma-ech"
  spec.version       = Metanorma::Ech::VERSION
  spec.authors       = ["p1d1d1"]
  spec.email         = ["mail@example.ch"]

  spec.summary       = "Metanorma processor for eCH standards (Switzerland)"
  spec.description   = <<~DESC
    Metanorma flavour for authoring eCH (E-Government CH) standards.
    Supports the official eCH document template with cover-page metadata,
    numbered sections, appendices, and the required boilerplate chapters.
  DESC
  spec.homepage      = "https://github.com/p1d1d1/metanorma-ech"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7"

  spec.files = Dir[
    "lib/**/*",
    "templates/**/*",
    "*.gemspec",
    "README.adoc",
    "LICENSE.txt"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "metanorma-standoc",   "~> 2.0"
  spec.add_dependency "isodoc-ech",          "~> 0.1"

  spec.add_development_dependency "rake",    "~> 13.0"
  spec.add_development_dependency "rspec",   "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
end

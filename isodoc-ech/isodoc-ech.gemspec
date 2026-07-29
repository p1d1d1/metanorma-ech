# frozen_string_literal: true

require_relative "lib/isodoc/ech/version"

Gem::Specification.new do |spec|
  spec.name          = "isodoc-ech"
  spec.version       = IsoDoc::Ech::VERSION
  spec.authors       = ["p1d1d1"]
  spec.email         = ["mail@example.ch"]

  spec.summary       = "IsoDoc output converters for eCH standards"
  spec.description   = "HTML, Word (.doc), and PDF output for metanorma-ech"
  spec.homepage      = "https://github.com/p1d1d1/metanorma-ech"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7"

  spec.files = Dir["lib/**/*", "templates/**/*", "*.gemspec", "README.adoc"]
  spec.require_paths = ["lib"]

  spec.add_dependency "isodoc"
end

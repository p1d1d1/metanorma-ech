# frozen_string_literal: true

require "metanorma"
require "metanorma-standoc"
require "isodoc-ech"

require_relative "ech/version"
require_relative "ech/validate"
require_relative "ech/converter"
require_relative "ech/processor"

module Metanorma
  module Ech
    Metanorma::Registry.instance.register(Metanorma::Ech::Processor)
  end
end

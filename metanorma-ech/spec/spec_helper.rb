# frozen_string_literal: true

require "metanorma-ech"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

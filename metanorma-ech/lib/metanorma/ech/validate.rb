# frozen_string_literal: true

module Metanorma
  module Ech
    class Validate < Standoc::Validate
      REQUIRED_FIELDS = {
        "ech-nummer" => "//bibdata/docnumber",
        "edition" => "//bibdata/edition",
        "ech-status" => "//bibdata/status/stage",
        "ech-ausgabedatum" => "//bibdata/date[@type='published']/on",
        "ech-working-group" => "//bibdata/ext/ext/ech-working-group",
      }.freeze

      PLACEHOLDER_RE = /\A[xX<]|\Ax\.x\.x\z|\AJJJJ|\Axx\z/

      def validate(doc)
        super
        validate_ech_metadata(doc)
      end

      private

      def validate_ech_metadata(doc)
        errors = []

        REQUIRED_FIELDS.each do |name, xpath|
          node = doc.at_xpath(xpath)
          value = node&.text

          if value.nil? || value.strip.empty?
            errors << "eCH: required metadata '#{name}' is missing"
          elsif PLACEHOLDER_RE.match?(value)
            errors << "eCH: metadata '#{name}' contains placeholder '#{value}'"
          end
        end

        return if errors.empty?

        errors.each { |e| warn e }

        raise StandardError,
              "eCH metadata validation failed (#{errors.size} errors)"
      end
    end
  end
end

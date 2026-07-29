# frozen_string_literal: true

module Metanorma
  module Ech
    class Validate < Standoc::Validate
      REQUIRED_ATTRS = %w[
        ech-nummer
        edition
        ech-status
        ech-ausgabedatum
        ech-working-group
      ].freeze

      PLACEHOLDER_RE = /\A[xX<]|\Ax\.x\.x\z|\AJJJJ|\Axx\z/

      def validate(doc)
        super
        validate_ech_metadata(doc)
      end

      private

      def validate_ech_metadata(doc)
        File.write("ech-debug.xml", doc.to_xml)
        exit
        # errors = []

        # REQUIRED_ATTRS.each do |attr|
        #   val = doc.attr(attr)

        #   if val.nil? || val.strip.empty?
        #     errors << "eCH: required attribute '#{attr}' is missing"
        #   elsif PLACEHOLDER_RE.match?(val)
        #     errors << "eCH: attribute '#{attr}' still contains placeholder value '#{val}'"
        #   end
        # end

        # return if errors.empty?

        # errors.each { |e| warn e }

        # raise StandardError,
        #       "eCH metadata validation failed (#{errors.size} error#{errors.size == 1 ? '' : 's'})"
      end
    end
  end
end

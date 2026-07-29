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
        REQUIRED_ATTRS.each do |attr|
          val = doc.attr(attr)
          if val.nil? || val.empty?
            @log.add(
              "Metadata",
              "eCH: required attribute :#{attr}: is missing")
          elsif PLACEHOLDER_RE.match?(val)
            @log.add(
              "Metadata",
              "eCH: attribute :#{attr}: still contains placeholder value '#{val}'")
          end
        end
      end
    end
  end
end

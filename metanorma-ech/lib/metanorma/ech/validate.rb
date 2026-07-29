# frozen_string_literal: true

module Metanorma
  module Ech
    module Validate
      # Warn if required cover-page fields are missing or use placeholder values.
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
        validate_required_sections(doc)
      end

      private

      def validate_ech_metadata(doc)
        REQUIRED_ATTRS.each do |attr|
          val = doc.attr(attr)
          if val.nil? || val.empty?
            @log.add("Metadata", nil, "eCH: required attribute :#{attr}: is missing")
          elsif PLACEHOLDER_RE.match?(val)
            @log.add("Metadata", nil, "eCH: attribute :#{attr}: still contains placeholder value '#{val}'")
          end
        end
      end

      def validate_required_sections(doc)
        xmldoc = doc.converter.instance_variable_get(:@draft)
        return unless xmldoc

        required = %w[
          //sections/clause[@type='scope']
          //sections/clause[@type='security']
          //bibliography
        ]
        required.each do |xpath|
          unless xmldoc.at(xpath)
            @log.add("Sections", nil, "eCH: required section missing (#{xpath})")
          end
        end
      end
    end
  end
end

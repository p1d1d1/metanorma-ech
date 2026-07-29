# frozen_string_literal: true

require "metanorma-standoc"
require_relative "front"
require_relative "validate"

module Metanorma
  module Ech
    # Asciidoctor backend for eCH standards.
    # Inherits generic ISO-Doc / Standoc behaviour and overrides only
    # what is specific to eCH.
    class Converter < Standoc::Converter
      XML_ROOT_TAG   = "ech-standard"
      XML_NAMESPACE  = "https://www.ech.ch/ns/metanorma"

      register_for "ech"

      # ---------------------------------------------------------------
      # Document metadata
      # ---------------------------------------------------------------

      def metadata_init(lang, script, locale, i18n)
        @meta = Metanorma::Ech::Front.new(lang, script, locale, i18n)
      end

      def docidentifier_cleanup(xmldoc)
        # Build the canonical eCH identifier:
        #   eCH-XXXX  vX.X.X  (YYYY-MM-DD)
        num    = xmldoc.at("//bibdata/docnumber")&.text
        ver    = xmldoc.at("//bibdata/version/revision-date")&.text ||
                 xmldoc.at("//bibdata/edition")&.text
        date   = xmldoc.at("//bibdata/date[@type='published']/on")&.text
        id_el  = xmldoc.at("//bibdata/docidentifier[@type='eCH']")
        return unless id_el && num

        id_el.content = ["eCH-#{num}", ver, date].compact.join("  ")
      end

      # ---------------------------------------------------------------
      # Section numbering helpers
      # ---------------------------------------------------------------

      # Appendix headings use the eCH "Anhang X" pattern (A, B, C …)
      APPENDIX_TITLES = %w[
        Referenzen\ &\ Bibliographie
        Mitarbeit\ &\ Überprüfung
        Abkürzungen\ und\ Glossar
        Änderungen\ gegenüber\ Vorversion
        Abbildungsverzeichnis
        Tabellenverzeichnis
      ].freeze

      # ---------------------------------------------------------------
      # Required boilerplate sections (auto-inserted if absent)
      # ---------------------------------------------------------------

      def boilerplate_file(_xmldoc)
        File.join(File.dirname(__FILE__), "boilerplate.xml")
      end
    end
  end
end

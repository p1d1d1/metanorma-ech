# frozen_string_literal: true

require "metanorma-standoc"

module Metanorma
  module Ech
    # Converts Asciidoctor document attributes into the XML bibdata block
    # that matches the eCH cover-page table:
    #
    #   Name                  → title
    #   eCH-Nummer            → docnumber
    #   Kategorie             → doctype / ech-kategorie
    #   Reifegrad             → ech-reifegrad
    #   Version               → edition
    #   Status                → ech-status
    #   Beschluss am          → date[@type="ratified"]
    #   Ausgabedatum          → date[@type="published"]
    #   Ersetzt Version       → ech-replaces
    #   Voraussetzungen       → ech-prerequisites
    #   Beilagen              → ech-annexes
    #   Sprachen              → language
    #   Fachgruppe            → ech-working-group
    #
    class Front < Standoc::Front
      # Map attribute name → XML element / processing method
      FIELD_MAP = {
        "ech-nummer"         => :docnumber,
        "ech-kategorie"      => :ech_kategorie,
        "ech-reifegrad"      => :ech_reifegrad,
        "edition"            => :edition,
        "ech-status"         => :ech_status,
        "ech-beschluss-am"   => :date_ratified,
        "ech-ausgabedatum"   => :date_published,
        "ech-replaces"       => :ech_replaces,
        "ech-prerequisites"  => :ech_prerequisites,
        "ech-annexes"        => :ech_annexes,
        "ech-working-group"  => :ech_working_group,
        "ech-languages"      => :ech_languages,
      }.freeze

      # Valid values for Kategorie (eCH vocabulary)
      KATEGORIEN = %w[
        Standard
        Hilfsmittel
        Grundlage
        Anleitung
        Rahmenwerk
      ].freeze

      # Valid values for Reifegrad
      REIFEGRADE = %w[
        Entwurf
        Vernehmlassung
        Genehmigt
        Aufgehoben
      ].freeze

      def metadata_author(node, xml)
        # eCH documents are published by the eCH association, not individual
        # authors.  We still allow overriding via :publisher: attribute.
        publisher = node.attr("publisher") || "Verein eCH"
        xml.contributor do |c|
          c.role **{ type: "publisher" }
          c.organization do |o|
            o.name publisher
            o.abbreviation "eCH"
            o.uri "https://www.ech.ch"
            o.address do |a|
              a.formattedAddress "Affolternstrasse 52, 8050 Zürich"
            end
          end
        end
        # Optional editor / working-group contact
        if (wg = node.attr("ech-working-group"))
          xml.contributor do |c|
            c.role **{ type: "author" }
            c.organization { |o| o.name wg }
          end
        end
      end

      def metadata_id(node, xml)
        num    = node.attr("ech-nummer") || "XXXX"
        ver    = node.attr("edition")    || "x.x.x"
        date   = node.attr("ech-ausgabedatum") || ""

        xml.docidentifier "eCH-#{num}", **{ type: "eCH" }
        xml.docidentifier "eCH-#{num}-#{ver}", **{ type: "eCH-long" }
        xml.docnumber num
      end

      def metadata_version(node, xml)
        ed = node.attr("edition") || "x.x.x"
        xml.edition ed
        if (replaces = node.attr("ech-replaces"))
          xml.relation **{ type: "updates" } do |r|
            r.bibitem do |b|
              num = node.attr("ech-nummer") || "XXXX"
              b.docidentifier "eCH-#{num}-#{replaces}", **{ type: "eCH" }
            end
          end
        end
      end

      def metadata_status(node, xml)
        status = node.attr("ech-status") || "Entwurf"
        xml.status { |s| s.stage status }
      end

      def metadata_date(node, xml)
        {
          "ratified"  => node.attr("ech-beschluss-am"),
          "published" => node.attr("ech-ausgabedatum"),
        }.each do |type, val|
          next unless val

          xml.date **{ type: type } do |d|
            d.on val
          end
        end
      end

      def metadata_language(node, xml)
        langs_raw = node.attr("ech-languages") ||
                    node.attr("language")      || "de"
        # The template lists primary + translation languages,
        # e.g. "de,fr" — we just record the primary for now.
        primary = langs_raw.split(/[,;]/).first.strip
        xml.language primary
        xml.script "Latn"
      end

      def metadata_ext(node, xml)
        super
        ech_ext(node, xml)
      end

      private

      def ech_ext(node, xml)
        xml.ext do |ext|
          ext.doctype(node.attr("doctype") || "standard")

          %w[kategorie reifegrad working-group prerequisites annexes].each do |k|
            val = node.attr("ech-#{k}")
            ext.send(:"ech_#{k.tr('-', '_')}", val) if val
          end
        end
      end
    end
  end
end

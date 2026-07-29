# frozen_string_literal: true

require "isodoc"

module IsoDoc
  module Ech
    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def word_doc_path(*args)
        File.join(@libdir, "../../../templates/word", *args)
      end

      # Map eCH-specific XML elements to the Word paragraph styles
      # defined in the original template.
      STYLE_MAP = {
        "title"         => "Titel",
        "subtitle"      => "Untertitel",
        "abstract"      => "Standard",
        "annex-title"   => "Anhang\u00dcberschrift",   # Anhang-Überschrift
        "caption"       => "Beschriftung",
        "table-text"    => "Tabellentext",
        "list-bullet-1" => "Aufz\u00e4hlung1CDB",
        "list-bullet-2" => "Aufz\u00e4hlung2CDB",
        "list-bullet-3" => "Aufz\u00e4hlung3CDB",
        "list-alpha-1"  => "Aufz\u00e4hlunga1CDB",
        "list-alpha-2"  => "Aufz\u00e4hlunga2CDB",
        "list-num-1"    => "Aufz\u00e4hlungNumm1CDB",
        "list-num-2"    => "Aufz\u00e4hlungNumm2CDB",
        "exchange-fmt"  => "Austauschformat",
        "note"          => "Platzhalter",
      }.freeze

      # Heading styles (index 1-9 → eCH heading style names)
      HEADING_STYLES = (1..9).map { |i| "berschrift#{i}" }.freeze

      def headings_override
        HEADING_STYLES
      end

      # Cover page: build the eCH metadata table as a Word table
      def word_cover(docxml)
        rows = build_cover_rows(docxml)
        word_table_from_rows(rows, col_widths: [2300, 7200])
      end

      private

      def build_cover_rows(docxml)
        [
          ["Name",            docxml.at("//bibdata/title[@type='main']")&.text],
          ["eCH-Nummer",      docxml.at("//bibdata/docnumber")&.text],
          ["Kategorie",       docxml.at("//bibdata/ext/ech_kategorie")&.text],
          ["Reifegrad",       docxml.at("//bibdata/ext/ech_reifegrad")&.text],
          ["Version",         docxml.at("//bibdata/edition")&.text,         { bold: true }],
          ["Status",          docxml.at("//bibdata/status/stage")&.text],
          ["Beschluss am",    docxml.at("//bibdata/date[@type='ratified']/on")&.text],
          ["Ausgabedatum",    docxml.at("//bibdata/date[@type='published']/on")&.text],
          ["Ersetzt Version", replaces(docxml),                             { bold: true }],
          ["Voraussetzungen", docxml.at("//bibdata/ext/ech_prerequisites")&.text],
          ["Beilagen",        docxml.at("//bibdata/ext/ech_annexes")&.text],
          ["Sprachen",        "Deutsch (Original), Französisch (Übersetzung)"],
          ["Fachgruppe",      docxml.at("//bibdata/ext/ech_working_group")&.text],
          ["Herausgeber / Vertrieb",
           "Verein eCH, Affolternstrasse 52, 8050 Zürich\nT 044 388 74 64 / info@ech.ch / www.ech.ch"],
        ].reject { |row| row[1].nil? || row[1].empty? }
      end

      def replaces(docxml)
        docxml.at("//bibdata/relation[@type='updates']//docidentifier")&.text
      end
    end
  end
end

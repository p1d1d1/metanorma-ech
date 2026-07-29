# frozen_string_literal: true

require "isodoc"

module IsoDoc
  module Ech
    class HtmlConvert < IsoDoc::HtmlConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def html_doc_path(*args)
        File.join(@libdir, "../../../templates/html", *args)
      end

      # Cover page: render the eCH metadata table before the TOC
      def make_body1(body, _docxml)
        body.div **{ class: "coverpage" } do |div|
          cover_metadata(div, _docxml)
        end
      end

      private

      def cover_metadata(div, docxml)
        div.table **{ class: "cover-table" } do |tbl|
          cover_row(tbl, "Name",            docxml.at("//bibdata/title[@type='main']")&.text)
          cover_row(tbl, "eCH-Nummer",      docxml.at("//bibdata/docnumber")&.text)
          cover_row(tbl, "Kategorie",       docxml.at("//bibdata/ext/ech_kategorie")&.text)
          cover_row(tbl, "Reifegrad",       docxml.at("//bibdata/ext/ech_reifegrad")&.text)
          cover_row(tbl, "Version",         docxml.at("//bibdata/edition")&.text, bold: true)
          cover_row(tbl, "Status",          docxml.at("//bibdata/status/stage")&.text)
          cover_row(tbl, "Beschluss am",    docxml.at("//bibdata/date[@type='ratified']/on")&.text)
          cover_row(tbl, "Ausgabedatum",    docxml.at("//bibdata/date[@type='published']/on")&.text)
          cover_row(tbl, "Ersetzt Version", replaces(docxml), bold: true)
          cover_row(tbl, "Voraussetzungen", docxml.at("//bibdata/ext/ech_prerequisites")&.text)
          cover_row(tbl, "Beilagen",        docxml.at("//bibdata/ext/ech_annexes")&.text)
          cover_row(tbl, "Sprachen",        languages_str(docxml))
          cover_row(tbl, "Fachgruppe",      docxml.at("//bibdata/ext/ech_working_group")&.text)
          cover_row(tbl, "Herausgeber / Vertrieb", publisher_str)
        end
      end

      def cover_row(tbl, label, value, bold: false)
        return if value.nil? || value.empty?

        tbl.tr do |tr|
          tr.td(**{ class: "cover-label" }) { |td| td << label }
          tr.td(**{ class: "cover-value" }) do |td|
            bold ? (td.strong { |s| s << value }) : (td << value)
          end
        end
      end

      def replaces(docxml)
        docxml.at("//bibdata/relation[@type='updates']//docidentifier")&.text
      end

      def languages_str(_docxml)
        "Deutsch (Original), Französisch (Übersetzung)"
      end

      def publisher_str
        "Verein eCH, Affolternstrasse 52, 8050 Zürich · T 044 388 74 64 · info@ech.ch · www.ech.ch"
      end
    end
  end
end

# frozen_string_literal: true

require "isodoc"

module IsoDoc
  module Ech
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      # Append "Anhang X —" prefix to annex titles, e.g.
      #   "Referenzen & Bibliographie"  →  "Anhang A — Referenzen & Bibliographie"
      def annex(docxml)
        counter = ("A".ord - 1)
        docxml.xpath("//annex").each do |a|
          counter += 1
          title = a.at("./title")
          next unless title

          letter = counter.chr
          title.content = "Anhang #{letter} \u2014 #{title.text}"
        end
        super
      end

      # Section numbering: top-level sections start at 1,
      # subsections at 1.1 etc.  Annexes are A, B, C …
      def clause_attrs(elem)
        attrs = super
        attrs
      end
    end

    class PdfConvert < IsoDoc::XslfoPdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def pdf_stylesheet(_docxml)
        File.join(@libdir, "../../../templates/pdf/ech.xsl")
      end
    end
  end
end

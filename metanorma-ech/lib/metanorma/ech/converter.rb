# frozen_string_literal: true

require "metanorma-standoc"

module Metanorma
  module Ech
    class Converter < Standoc::Converter
      XML_ROOT_TAG  = "ech-standard"
      XML_NAMESPACE = "https://www.ech.ch/ns/metanorma"

      register_for "ech"

      def boilerplate_file(_xmldoc)
        File.join(File.dirname(__FILE__), "boilerplate.xml")
      end

      def metadata_author(node, xml)
        publisher = node.attr("publisher") || "Verein eCH"
        xml.contributor do |c|
          c.role type: "publisher"
          c.organization do |o|
            o.name publisher
            o.abbreviation "eCH"
            o.uri "https://www.ech.ch"
          end
        end
        if (wg = node.attr("ech-working-group"))
          xml.contributor do |c|
            c.role type: "author"
            c.organization { |o| o.name wg }
          end
        end
      end

      def metadata_id(node, xml)
        num = node.attr("ech-nummer") || "XXXX"
        ver = node.attr("edition")    || "x.x.x"
        xml.docidentifier "eCH-#{num}", type: "eCH"
        xml.docidentifier "eCH-#{num}-#{ver}", type: "eCH-long"
        xml.docnumber num
      end

      def metadata_version(node, xml)
        ed = node.attr("edition") || "x.x.x"
        xml.edition ed
        if (replaces = node.attr("ech-replaces"))
          num = node.attr("ech-nummer") || "XXXX"
          xml.relation type: "updates" do |r|
            r.bibitem do |b|
              b.docidentifier "eCH-#{num}-#{replaces}", type: "eCH"
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
          xml.date type: type do |d|
            d.on val
          end
        end
      end

      def metadata_language(node, xml)
        langs_raw = node.attr("ech-languages") ||
                    node.attr("language") || "de"
        primary = langs_raw.split(/[,;]/).first.strip
        xml.language primary
        xml.script "Latn"
      end

      def metadata_ext(node, xml)
        super
        xml.ext do |ext|
          ext.doctype node.attr("doctype") || "standard"
          %w[kategorie reifegrad working-group prerequisites annexes].each do |k|
            val = node.attr("ech-#{k}")
            ext.send(:"ech_#{k.tr('-', '_')}", val) if val
          end
        end
      end
    end
  end
end

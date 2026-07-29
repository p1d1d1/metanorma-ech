# frozen_string_literal: true

require "metanorma/processor"

module Metanorma
  module Ech
    class Processor < Metanorma::Processor
      def initialize
        @short = :ech
        @input_format = :asciidoc
        @asciidoctor_backend = :ech
      end

      def output_formats
        {
          presentation: "presentation.xml",
          html:         "html",
          doc:          "doc",
          pdf:          "pdf",
        }
      end

      def version
        "Metanorma::Ech #{Metanorma::Ech::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options = {})
        case format
        when :html
          IsoDoc::Ech::HtmlConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :doc
          IsoDoc::Ech::WordConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::Ech::PdfConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::Ech::PresentationXMLConvert.new(options).convert(inname, isodoc_node, nil, outname)
        else
          raise "Unknown output format #{format}"
        end
      end
    end
  end
end

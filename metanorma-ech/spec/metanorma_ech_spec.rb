# frozen_string_literal: true

require "spec_helper"

RSpec.describe Metanorma::Ech do
  it "registers the eCH processor" do
    expect(Metanorma::Registry.instance.find_processor(:ech))
      .to be_a(Metanorma::Ech::Processor)
  end

  describe "output formats" do
    subject(:processor) { Metanorma::Ech::Processor.new }

    it "declares html, doc, and pdf" do
      expect(processor.output_formats.keys).to include(:html, :doc, :pdf)
    end
  end

  describe "version" do
    it "returns a version string" do
      expect(Metanorma::Ech::Processor.new.version)
        .to match(/Metanorma::Ech \d+\.\d+\.\d+/)
    end
  end
end

RSpec.describe "eCH document conversion" do
  let(:input) do
    <<~ASCIIDOC
      = Teststandard
      :ech-nummer: 9999
      :edition: 0.1.0
      :ech-status: Entwurf
      :ech-kategorie: Standard
      :ech-reifegrad: Entwurf
      :ech-ausgabedatum: 2025-01-01
      :ech-working-group: Testgruppe
      :mn-document-class: ech

      == Einleitung

      === Status

      Entwurf.

      === Anwendungsgebiet

      Testdokument.

      == Sicherheitsüberlegungen

      Keine besonderen Sicherheitsüberlegungen.

      [appendix]
      == Referenzen & Bibliographie

      Keine.

      [appendix]
      == Mitarbeit & Überprüfung

      [appendix]
      == Abkürzungen und Glossar

      [appendix]
      == Änderungen gegenüber Vorversion

      Dies ist die erste Version.
    ASCIIDOC
  end

  it "converts to XML without errors" do
    xml = Metanorma::Compile.new.compile(
      input,
      type: "ech",
      extension_keys: [:xml],
    ).first
    expect(xml).to include("eCH-9999")
  end

  it "includes docidentifier with eCH number" do
    xml = Metanorma::Compile.new.compile(input, type: "ech", extension_keys: [:xml]).first
    expect(xml).to match(/docidentifier[^>]*type="eCH"[^>]*>eCH-9999/)
  end
end

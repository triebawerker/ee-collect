# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_steuerung'
require 'fileutils'
require 'konfiguration'

sandbox_pfad = File.dirname(File.dirname(__FILE__)) + "/temp"
ziel_mappenpfad = sandbox_pfad + "/test_excel_steuerung.xls"

describe ExcelSteuerung, "zur Neu-Erzeugung" do
  before :each do
    @es = ExcelSteuerung.erstelle_mappe(ziel_mappenpfad)
  end

  after :each do
    @es.schliessen
  end

  it "sollte existieren" do
    File.exist?(ziel_mappenpfad).should == true
    @es.oeffnen
  end

  it "sollte offen sein" do
    @es.offen?.should be_true
  end
end


describe ExcelSteuerung, "mit existierenden Mappen" do
  before :all do
    @datei_namen = ["2 Days in Paris 06 09.xls", "We own the Night 06 09.xls"]

    @arbeits_dateipfade = @datei_namen.map {|datei_name |REPORT_BASIS_PFAD + "/ACME/2009/2009 IIQ/" + datei_name}

  end


  before(:each) do
    @es = ExcelSteuerung.new(@arbeits_dateipfade[0])
   
    @es.oeffnen
  end

  after(:each) do
    @es.schliessen
  end


  it "sollte sich öffnen und auch wieder schliessen lassen" do
    @es.mappe.should_not be_nil
    @es.offen?.should == true
    @es.offen?.should be_true
    @es.sheet.should_not be_nil

    @es.schliessen
    @es.offen?.should == false

    @es.oeffnen
    @es.offen?.should == true
  end




  it "sollte benannte Felder aabfragen können" do
    @es.lese_feld("title").should == "2 Days in Paris"
  end

  it "sollte Zeilen finden können" do
    proc { zeile = @es.finde_zelle(:zeile, /Total/) }.should raise_error

    zeile = @es.finde_zelle(:zeile, /Licensor Share Total/mi)
    zeile.should == 43
    @es.lese_feld("A#{zeile+1}").should == "Licensor Share Total"
  end

  it "sollte Zeilen in We own the Night 06 09.xls finden können" do
    es_we_own = ExcelSteuerung.new(@arbeits_dateipfade[1])
    es_we_own.oeffnen
    proc { zeile = es_we_own.finde_zelle(:zeile, /Total/) }.should raise_error

    zeile = es_we_own.finde_zelle(:zeile, /^MG$/mi)
    zeile.should == 10
    es_we_own.lese_feld("A#{zeile+1}").should == "MG"
    es_we_own.schliessen
  end

  it "sollte Spalten finden können" do
    proc { zeile = @es.finde_zelle(:spalte, /Total/) }.should raise_error
    spalte = @es.finde_zelle(:spalte, /Total\s+Licensor/mi)
    spalte.should == 3
    @es.lese_feld("D4").should == "Total\nLicensor"
  end

  it "sollte Zellen mit mehreren Bedingungen finden können" do
    proc { zeile = @es.finde_zelle(:zeile, [/Total/]) }.should raise_error
    zeile = @es.finde_zelle(:zeile, [/Licensor Share Total/mi, /Licensor Final HE/mi])
    zeile.should == 43
    @es.lese_feld("A#{zeile+1}").should == "Licensor Share Total"
  end


  it "Sollte zugewiesene Namen überschreiben können" do
    @es.name_zuweisen("Heinz", 0,8)
    @es.lese_feld("Heinz").should be_nil
    @es.name_zuweisen("Heinrich", 0,8)
    @es.lese_feld("Heinrich").should be_nil
  end

#  it "sollte Zellen direkt benennen können" do
#
#  end

end


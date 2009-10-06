# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_steuerung'
require 'fileutils'


describe ExcelSteuerung do
  before :all do
    @datei_namen = ["2 Days in Paris 06 09.xls", "We own the Night 06 09.xls"]
    orig_dateipfad = "O:/EEAP/REPORTING/Test - DISTRIBUTORS/ACME/2009/2009 IIQ/"
    @arbeits_ordnerpfad = "C:/Projects/Sandbox/2 Days in Paris.xls"
    #FileUtils.rm_f @arbeits_dateipfad
    @arbeits_dateipfad = @arbeits_ordnerpfad + "/" + @datei_namen.first
    @datei_namen.each do |dateiname|
      FileUtils.copy orig_dateipfad, @arbeits_dateipfad + "/" + dateiname
    end
  end


  before(:each) do
    @es = ExcelSteuerung.new(@arbeits_dateipfad)
    #@es2 = ExcelSteuerung.new("O:/EEAP/REPORTING/Test - DISTRIBUTORS/Xyz_Fixtures/2009/2009 IQ/2 Days in Paris 03 09.xls")
    @es.oeffnen
  end

  after(:each) do
    @es.schliessen
  end


  it "sollte sich öffnen lassen" do
    @es.mappe.should_not be_nil
    @es.mappe.ActiveSheet.should_not be_nil
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
    proc { zeile = @es.finde_zelle(:zeile, /Total/) }.should raise_error

    zeile = @es.finde_zelle(:zeile, /^MG$/mi)
    zeile.should == 10
    @es.lese_feld("A#{zeile+1}").should == "Licensor Share Total"
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

  it "Sollte Namen zuweisen können" do
    proc{@es.lese_feld("Heinz")}.should raise_error
    @es.name_zuweisen("Heinz", 3,0)
    @es.lese_feld("Heinz").should be_nil
  end

  it "Sollte zugewiesene Namen überschreiben können" do
    @es.name_zuweisen("Heinz", 3,0)
    @es.lese_feld("Heinz").should be_nil
    @es.name_zuweisen("Heinz", 11,0)
    @es.lese_feld("Heinz").should == "ACME"
  end

  it "sollte Zellen direkt benennen können" do

  end

end


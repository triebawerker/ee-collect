# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_steuerung'
require 'fileutils'


describe ExcelSteuerung do
  before :all do
    orig_dateipfad = "O:/EEAP/REPORTING/Test - DISTRIBUTORS/Xyz_Fixtures/2009/2009 IIQ/2 Days in Paris 06 09.xls"
    @arbeits_dateipfad = "C:/Projects/Sandbox/2 Days in Paris.xls"
    FileUtils.copy orig_dateipfad, @arbeits_dateipfad
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

  it "sollte Zellen finden können" do
    proc { erg = @es.finde_zelle(/Total/) }.should raise_error
    erg = @es.finde_zelle(/Licensor Share Total/)
    erg.should == {:zeile => 43, :spalte => 0}
    z = erg[:zeile]
    @es.lese_feld("A#{z+1}").should == "Licensor Share Total"
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


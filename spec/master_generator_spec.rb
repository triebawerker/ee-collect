# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'master_generator'

sandbox_pfad = File.dirname(File.dirname(__FILE__)) + "/temp"
ziel_mappenpfad = sandbox_pfad + "/test_master_mappe.xls"

licensees = %[ACME]
describe MasterGenerator do
  before(:each) do
    jahr = 2009
    quartal = 2
    @master_generator = MasterGenerator.new(ziel_mappenpfad, licensees, jahr, quartal)
  end

  it "sollte Excel-Datei erzeugen" do
    @master_generator.erzeuge_mappe
    File.exist?(ziel_mappenpfad).should == true
  end
end


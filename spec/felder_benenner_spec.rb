# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'felder_benenner'

require 'sheet_ausleser'

describe FelderBenenner do
  #  before(:all) do
  #    orig_ordner = "O:/EEAP/REPORTING/Test - DISTRIBUTORS/Xyz_Fixtures/2009"
  #    arbeits_ordner = orig_ordner.gsub("Fixtures", "Sandbox")
  #    FileUtils.rm_rf arbeits_ordner
  #    FileUtils.cp_r orig_ordner, arbeits_ordner
  #    puts "fertig kopiert"
  #  end

  it "sollte licensor_share_total benennen" do
    jahr = 2009
    quartal = 2
    # Hier noch richtige Licensee Werte nehmen
    licensees = ["*"]
    licensees.each do |licensee|
      @felder_benenner = FelderBenenner.new(licensee, jahr, quartal)

      namens_zuordnung = {
        "licensor_share_total" => {
          :zeile => /Licensor Share Total/mi,
          :spalte => /Total\s+Licensor/mi
        },
        "currency" => {
          :zeile =>  /^in ...$/,
          :spalte => /Total\s+Licensor/mi,
          :mehrfach_ok => true
        },
        "title"    => {
          :zeile  => 0,
          :spalte => 0
        }
      }

    
      @felder_benenner.weise_zu(namens_zuordnung)

      sheet_ausleser1 = SheetAusleser.new(jahr, quartal)
    end
    sheet_ausleser1.each do |excel_steuerung|
      excel_steuerung.lese_feld(name).should_not be_nil
    end
  end
end


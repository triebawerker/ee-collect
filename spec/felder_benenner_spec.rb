# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'felder_benenner'

require 'sheet_ausleser'


namens_zuordnung = {
  "licensor_share_total" => {
    :zeile => [/Licensor Share Total/mi, /Licensor Final HE/mi],
    :spalte => /Total\s+Licensor/mi
  },
  "currency" => {
    :zeile =>  /(^|[tT]otal.*)in ...$/m,
    :spalte => /Total\s+Licensor/mi
  },
  "title"    => {
    :zeile  => 0,
    :spalte => 0
  },
  "minimum_guarantee" => [{
    :zeile  => /^MG$/,
    :spalte => /Total\s+Licensor/mi,
  },{
    :zeile  => /^MG$/,
    :spalte => /\ATotal\Z/mi,
  }]
}


describe FelderBenenner do
  licensees = ["Soyuzx", "Palace", "KinoSwiat"]
  jahr = 2009
  quartal = "II"

  licensees.each do |licensee|
    describe "mit #{licensee}" do
      @felder_benenner = FelderBenenner.new(licensee, jahr, quartal)
      @felder_benenner.weise_zu(namens_zuordnung)
  #    orig_ordner = "O:/EEAP/REPORTING/Test - DISTRIBUTORS/Xyz_Fixtures/2009"
  #    arbeits_ordner = orig_ordner.gsub("Fixtures", "Sandbox")
  #    FileUtils.rm_rf arbeits_ordner
  #    FileUtils.cp_r orig_ordner, arbeits_ordner
  #    puts "fertig kopiert"


      #exceliterator = ExcelIterator.new(licensee, jahr, quartal)
      Dir["O:/EEAP/REPORTING/Test - DISTRIBUTORS/#{licensee}/#{jahr}/#{jahr} #{quartal}Q*/*.xls*"].each do |pfad|
        #.each do |excel_steuerung|
        p [:test_einrichtung, pfad]
        it "sollte alle Namen in #{pfad} finden" do
          p [:test_durchlauf, pfad]
          excel_steuerung = ExcelSteuerung.new(pfad)
          begin
            excel_steuerung = ExcelSteuerung.new(pfad)
            excel_steuerung.oeffnen

            namens_zuordnung.each {|name,val| excel_steuerung.lese_feld(name).should_not be_nil}

          rescue Exception => e
            puts "Fahler bei #{pfad}"
            puts e.message
            puts e.backtrace.first(12).join("\n")
          ensure
            excel_steuerung.schliessen rescue nil
          end
        end
      end
    end
  end
end


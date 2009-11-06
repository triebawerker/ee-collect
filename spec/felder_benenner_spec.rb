# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'felder_benenner'

require 'sheet_ausleser'


if nil #describe FelderBenenner, " für Agreement Number" do
  limit = 20000
  licensees = ["ACME"] #["Soyuz", "Palace", "KinoSwiat"]
  #licensees = Dir.entries(REPORT_BASIS_PFAD).select {|dir_name| dir_name !~ /^(\.|ZZZ)/ and dir_name !~ /\.xls.+$/}
  jahr = 2009
  quartal = "II"

  i = 0
  licensees.each do |licensee|
    describe "mit #{licensee}" do
      @felder_benenner = FelderBenenner.new(licensee, jahr, quartal)
      p @felder_benenner.neue_felder_benennen #(:limit => limit)
      
      i += 1
      break if i > 1
    end
  end


end


#__END__

describe FelderBenenner, " für existierende Namen" do
  licensees = ["Soyuzx", "Palace", "KinoSwiat"]
  jahr = 2009
  quartal = "II"

  licensees.each do |licensee|
    describe "mit #{licensee}" do
      @felder_benenner = FelderBenenner.new(licensee, jahr, quartal)
      @felder_benenner.bestehende_felder_benennen(FILMSHEET_NAMEN_ERKENNUNGSZEICHEN)
  #    orig_ordner = "#{REPORT_BASIS_PFAD}/Xyz_Fixtures/2009"
  #    arbeits_ordner = orig_ordner.gsub("Fixtures", "Sandbox")
  #    FileUtils.rm_rf arbeits_ordner
  #    FileUtils.cp_r orig_ordner, arbeits_ordner
  #    puts "fertig kopiert"


      exceliterator = ExcelIterator.new(licensee, jahr, quartal)
      exceliterator.each_pfad do |pfad, licensee|
        #.each do |excel_steuerung|
        p [:test_einrichtung, pfad]
        it "sollte alle Namen in #{pfad} finden" do
          p [:test_durchlauf, pfad]
          excel_steuerung = ExcelSteuerung.new(pfad)
          begin
            excel_steuerung = ExcelSteuerung.new(pfad)
            excel_steuerung.oeffnen

            FILMSHEET_NAMEN_ERKENNUNGSZEICHEN.each {|name,val| excel_steuerung.lese_feld(name).should_not be_nil}

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

if nil #describe FelderBenenner, " für neue Namen" do
  licensees = ["Palace"] #, "KinoSwiat"]
  jahr = 2009
  quartal = "II"

  licensees.each do |licensee|
    describe "mit #{licensee}" do
      @felder_benenner = FelderBenenner.new(licensee, jahr, quartal)
      @felder_benenner.bestehende_felder_benennen(FILMSHEET_NAMEN_ERKENNUNGSZEICHEN)
  #    orig_ordner = "#{REPORT_BASIS_PFAD}/Xyz_Fixtures/2009"
  #    arbeits_ordner = orig_ordner.gsub("Fixtures", "Sandbox")
  #    FileUtils.rm_rf arbeits_ordner
  #    FileUtils.cp_r orig_ordner, arbeits_ordner
  #    puts "fertig kopiert"


      exceliterator = ExcelIterator.new(licensee, jahr, quartal)
      exceliterator.each_pfad do |pfad, licensee|
        #.each do |excel_steuerung|
        p [:test_einrichtung, pfad]
        it "sollte alle Namen in #{pfad} finden" do
          p [:test_durchlauf, pfad]
          excel_steuerung = ExcelSteuerung.new(pfad)
          begin
            excel_steuerung = ExcelSteuerung.new(pfad)
            excel_steuerung.oeffnen

            FILMSHEET_NAMEN_ERKENNUNGSZEICHEN.each {|name,val| excel_steuerung.lese_feld(name).should_not be_nil}

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


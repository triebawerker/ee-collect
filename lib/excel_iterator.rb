# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_steuerung'
require 'konfiguration'

class ExcelIterator
  def initialize(licensee, jahr, quartal)
    @licensee, @jahr, @quartal = licensee, jahr, quartal
    if @quartal.is_a?(Integer) then
      #@quartal = %w[I II III IV] [quartal-1]
      @quartal = case quartal
      when 1 then "I"
      when 2 then "II"
      when 3 then "III"
      when 4 then "IV"
      end
    end
  end

  def each_pfad
    Dir["#{REPORT_BASIS_PFAD}/#{@licensee}/#{@jahr}/#{@jahr} #{@quartal}Q*/*.xls*"].each do |pfad|
      next if pfad =~ /^ZZZ/
      yield pfad
    end    
  end


  def each
    each_pfad do |pfad|
      puts pfad
      begin
        excel_steuerung = ExcelSteuerung.new(pfad)
        excel_steuerung.oeffnen
        yield excel_steuerung
      rescue Exception => e
        puts "Fehler bei #{pfad}"
        puts e.message
        puts e.backtrace.first(12).join("\n")
      ensure
        excel_steuerung.schliessen rescue puts "konnte #{pfad} nicht schließen"
      end
    end
  end
end

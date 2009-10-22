# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_steuerung'
require 'sheet_ausleser'

AUSGABE_FELDER = [:licensee, :title, :agreement_number, :licensor_share_total]

class MasterGenerator

  def initialize(ziel_mappenpfad, licensees, jahr, quartal)
    @ziel_mappenpfad = ziel_mappenpfad
    @licensees, @jahr, @quartal = licensees, jahr, quartal

    
  end

  def erzeuge_mappe
    @mappen_steuerung = ExcelSteuerung.erstelle_mappe(@ziel_mappenpfad)
    @blatt = @mappen_steuerung.sheet
    @excel_zeilnr = 1

    AUSGABE_FELDER.each_with_index do |feld_sym, index|
      @blatt.Cells(@excel_zeilnr, index+1).Value = feld_sym.to_s
    end

    gesamt_iteration do |film_sheet|

      @excel_zeilnr += 1
      schreibe_excel_zeile(film_sheet)

    end

    @mappen_steuerung.schliessen
  end

  def schreibe_excel_zeile(film_sheet)
    @excel_zeilnr
    
    
    AUSGABE_FELDER.each_with_index do |feld_sym, index|
      wert = film_sheet.send(feld_sym)
      @blatt.Cells(@excel_zeilnr, index+1).Value = wert
    end
  end


  def gesamt_iteration
    durchl = 0
    @licensees.each do |licensee|
      sheet_ausleser = SheetAusleser.new(licensee, @jahr, @quartal)
      sheet_ausleser.each do |film_sheet|
        durchl += 1
        #break if durchl > 10
        yield film_sheet
      end
    end
  end
end

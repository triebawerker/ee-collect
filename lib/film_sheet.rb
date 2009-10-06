# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_steuerung'

class FilmSheet
  def initialize(pfad_zur_mappe)
    @excel_steuerung = ExcelSteuerung.new(pfad_zur_mappe)
    @excel_steuerung.oeffnen
  end

  def licensor_share_total
    @excel_steuerung.lese_feld("lst")
  end

  def schliessen
    @excel_steuerung.schliessen
  end
end

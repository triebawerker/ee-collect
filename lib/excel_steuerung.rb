# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'win32ole'

$excel = WIN32OLE.new("Excel.Application")
$excel.Visible = true

class ExcelSteuerung
  attr_reader :mappe

  def initialize(dateipfad)
    @dateipfad = dateipfad
  end

  def oeffnen
    @mappe = $excel.Workbooks.Open(@dateipfad.gsub("/","\\"))
  end

  def schliessen
    @mappe.Save
    @mappe.Close
  end

  def lese_feld(feldname)
    @mappe.ActiveSheet.Range(feldname).Value
  end

  # zeilen_index, spalten_index beginnen bei Null
  # spalten_index = 0 ---> Spalte "A"
  def name_zuweisen(name, zeilen_index, spalten_index)
    alle_spalten_buchstaben = ("A" .. "Z").to_a
    spalten_buchstabe = alle_spalten_buchstaben[spalten_index]
    zeilen_nr = zeilen_index+1
    @mappe.Names.Add( "Name" => name, "RefersTo" => "=$#{spalten_buchstabe}$#{zeilen_nr}")
  end

  def finde_zelle(erkennungszeichen, optionen = {})
    inhalts_matrix = mappe.ActiveSheet.UsedRange.Value

    gefundene = []

    inhalts_matrix.each_with_index do |zeile, zeilen_index|
      zeile.each_with_index do |wert, spalten_index|
        next unless wert.is_a? String
        if wert =~ erkennungszeichen
          gefundene << [zeilen_index, spalten_index]
        end
      end
    end

    raise "#{erkennungszeichen.inspect} nicht gefunden" if gefundene == []
    unless optionen[:mehrfach_ok]
      raise "Kennung #{erkennungszeichen.inspect} doppelt gefunden" if gefundene.size > 1
    end
    
    erg_zeile, erg_spalte = gefundene.first

    { :zeile  => erg_zeile,
      :spalte => erg_spalte
    }
  end


end

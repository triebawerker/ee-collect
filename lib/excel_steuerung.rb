# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'win32ole'

$excel = WIN32OLE.new("Excel.Application")
#$excel.Visible = true

XL_LocalSessionChanges = 2
XL_Excel8 = 56

class ExcelSteuerung
  attr_reader :mappenpfad
  attr_reader :licensee

  def initialize(mappenpfad)
    @mappenpfad = mappenpfad
  end

  def self.erstelle_mappe(mappenpfad)
    mappe = $excel.Workbooks.Add
    p [XL_LocalSessionChanges, XL_Excel8]
    $excel.DisplayAlerts = false
    mappe.SaveAs("Filename" =>mappenpfad, "FileFormat" => XL_Excel8) #
    #hat nicht funktioniert: , "ConflictResolution" => XL_LocalSessionChanges)
    $excel.DisplayAlerts = true
    new(mappenpfad).oeffnen
  end

  def oeffnen
    @mappe = $excel.Workbooks.Open(@mappenpfad.gsub("/","\\"))
    self
  end

  def offen?
    not @mappe.nil?
  end

  def schliessen
    raise "nicht geöffnete Mappe kann nicht geschlossen werden" unless offen?
    @mappe.Save
    @mappe.Close
    @mappe = nil
  end

  def mappe
    raise "Mappe nicht geöffnet" unless offen?
    @mappe
  end
  def sheet
    mappe.Activesheet
  end

  def lese_feld(feldname)
    sheet.Range(feldname).Value
  end

  # zeilen_index, spalten_index beginnen bei Null
  # spalten_index = 0 ---> Spalte "A"
  def name_zuweisen(name, zeilen_index, spalten_index)
    alle_spalten_buchstaben = ("A" .. "Z").to_a
    spalten_buchstabe = alle_spalten_buchstaben[spalten_index]
    zeilen_nr = zeilen_index+1
    @mappe.Names.Add( "Name" => name, "RefersTo" => "=$#{spalten_buchstabe}$#{zeilen_nr}")
  end

  def finde_zelle(zeile_spalte, erkennungszeichen_array, optionen = {})

    erkennungszeichen_array = [erkennungszeichen_array] unless erkennungszeichen_array.is_a?(Array)

    inhalts_matrix = sheet.UsedRange.Value


    gefundene = nil

    erkennungszeichen_array.each do |erkennungszeichen|
      gefundene = []

      inhalts_matrix.each_with_index do |zeile, zeilen_index|
        zeile.each_with_index do |wert, spalten_index|
          next unless wert.is_a?(String)
          #p [wert =~ erkennungszeichen, wert, erkennungszeichen]
          if erkennungszeichen =~ wert
            #p [zeilen_index, spalten_index]
            interessant_gefunden = case zeile_spalte
            when :zeile  then zeilen_index
            when :spalte then spalten_index
            end
            gefundene << interessant_gefunden
          end
        end
        gefundene.uniq! if zeile_spalte == :zeile
      end

      if gefundene != []
        raise "Kennung #{erkennungszeichen.inspect} doppelt gefunden" if gefundene.size > 1
        break
      end
    end

    raise "#{erkennungszeichen_array.inspect} nicht gefunden" if gefundene == []
    
    gefundene.first
  end


end

# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'konfiguration'
require 'excel_steuerung'

require 'utilities'

class FilmSheet
  attr_reader :excel_steuerung
  def initialize(pfad_zur_mappe_oder_excel_steuerung)
    case pfad_zur_mappe_oder_excel_steuerung
    when ExcelSteuerung
      @excel_steuerung = pfad_zur_mappe_oder_excel_steuerung
    else
      @excel_steuerung = ExcelSteuerung.new(pfad_zur_mappe_oder_excel_steuerung)
    end
    
    @excel_steuerung.oeffnen unless @excel_steuerung.offen?

    mappenpfad = @excel_steuerung.mappenpfad

    relativer_mappenpfad = mappenpfad[REPORT_BASIS_PFAD.size .. -1]
    if relativer_mappenpfad =~ /^\/([^\/]+)\//
      @licensee = $1
    else
      raise "Finde keinen Licensee im Pfad #{mappenpfad} (relativ: #{relativer_mappenpfad})"
    end

  end

  def schliessen
    @excel_steuerung.schliessen
  end

  def licensor_share_total
    @excel_steuerung.lese_feld("licensor_share_total")
  end

  def title
    @excel_steuerung.lese_feld("title")
  end

  def licensee
    @licensee
  end

  def agreement_number
    @excel_steuerung.lese_feld("agreement_number")
  end

  def benenne_vorhandene_felder_entsprechend_zuordnung(zuordnung)
    zuordnung.each do |name, erkennungszeichen_array|
      erkennungszeichen_array = [erkennungszeichen_array] unless erkennungszeichen_array.is_a?(Array)
      erkennungszeichen_array.each do |erkennungszeichen|
        zeile_spalte_paar = [:zeile, :spalte].map do |zeile_oder_spalte|
          if erkennungszeichen[zeile_oder_spalte].is_a?(Integer)
            erkennungszeichen[zeile_oder_spalte]
          else
            excel_steuerung.finde_zelle(zeile_oder_spalte, erkennungszeichen[zeile_oder_spalte])
          end
        end

        excel_steuerung.name_zuweisen(name, *zeile_spalte_paar)
        if excel_steuerung.lese_feld(name) then break end
      end

      raise "Feld mit dem Namen #{name} ist leer!!!" if excel_steuerung.lese_feld(name).nil?
    end

  end

  def trage_agreement_number_ein(alle_film_datas)
    zeile  = excel_steuerung.finde_zelle(:zeile, /^[tT]otal/)
    spalte = 0

    ziel_zelle = excel_steuerung.sheet.Cells(zeile+1, spalte+1)

    if ziel_zelle.Value.nil? or ziel_zelle.Value =~ /^(EE|AV).{1,8}-.{1,8}$/
      excel_steuerung.name_zuweisen("agreement_number", zeile, spalte)
    else
      raise "Feld #{[zeile, spalte].inspect} muss leer sein! Gefunden: #{ziel_zelle.Value}"
    end

    ziel_zelle.Value = agreement_number_aus_filmdata(alle_film_datas)
  end

  def agreement_number_aus_filmdata(alle_film_datas)
    passende_filme = alle_film_datas.select do |film_data|
      film_data.distributor =~ Regexp.licensee_matcher(licensee) and
        film_data.title.gsub(/\([^)]+\)/,"").gsub(/[.,]/,"") =~ Regexp.title_matcher(title)
    end

    case passende_filme.size
    when 0
      raise "Für Filmsheet #{title} bei Licensee #{licensee} wurde kein 'Verkauf'-Datensatz in ILDA  gefunden"
    when 1
      # nur hier OK
    else
      meldung_string = "Für Filmsheet #{title} bei Licensee #{licensee} wurden #{passende_filme.size} 'Verkauf'-Datensätze in ILDA gefunden"
      begin
        meldung_string += "\nUnd zwar:\n" + passende_filme.map(&:inspect).join("\n")
      rescue
        nil
      end
      raise meldung_string
    end

    passender_film = passende_filme.first

    passender_film.agreement_number
  end

  
end

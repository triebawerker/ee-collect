# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_iterator'

require 'konfiguration'

require 'film_data'

class FelderBenenner
  def initialize(licensee, jahr, quartal)
    @iterator = ExcelIterator.new(licensee, jahr, quartal)
  end

  def bestehende_felder_benennen(zuordnung)
    @iterator.each do |es|
           
      zuordnung.each do |name, erkennungszeichen_array|
        erkennungszeichen_array = [erkennungszeichen_array] unless erkennungszeichen_array.is_a?(Array)
        erkennungszeichen_array.each do |erkennungszeichen|
          zeile_spalte_paar = [:zeile, :spalte].map do |zeile_oder_spalte|
            if erkennungszeichen[zeile_oder_spalte].is_a?(Integer)
              erkennungszeichen[zeile_oder_spalte]
            else
              es.finde_zelle(zeile_oder_spalte, erkennungszeichen[zeile_oder_spalte])
            end
          end

          es.name_zuweisen(name, *zeile_spalte_paar)
          if es.lese_feld(name) then break end
        end

        raise "Feld mit dem Namen #{name} ist leer!!!" if es.lese_feld(name).nil?
      end
    end
  end

  def neue_felder_benennen(options = nil)
    alle_film_datas = FilmData.alle(options)

    durchlaufene = erfolgreiche = 0

    @iterator.each do |excel_steuerung|
      durchlaufene += 1

      zeile  = excel_steuerung.finde_zelle(:zeile, /^[tT]otal/)
      spalte = 0

      ziel_zelle = excel_steuerung.sheet.Cells(zeile+1, spalte+1)

      if ziel_zelle.Value.nil? or ziel_zelle.Value =~ /^(EE|AV).{1,8}-.{1,8}$/
        excel_steuerung.name_zuweisen("agreement_number", zeile, spalte)
      else
        raise "Feld #{[zeile, spalte].inspect} muss leer sein! Gefunden: #{ziel_zelle.Value}"
      end

      film_sheet = FilmSheet.new(excel_steuerung)
      ziel_zelle.Value = film_sheet.agreement_number_aus_filmdata(alle_film_datas)

      erfolgreiche += 1
    end
    {:durchlaufene => durchlaufene, :erfolgreiche => erfolgreiche}
  end

end

# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'sheet_ausleser'

require 'konfiguration'

require 'film_data'

require 'film_sheet'

class FelderBenenner
  def initialize(licensee, jahr, quartal)
    @iterator = SheetAusleser.new(licensee, jahr, quartal)
  end

  def bestehende_felder_benennen(zuordnung)
    @iterator.each do |film_sheet|
      excel_steuerung = film_sheet.excel_steuerung
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
  end

  def neue_felder_benennen(options = nil)
    alle_film_datas = FilmData.alle(options)

    durchlaufene = erfolgreiche = 0

    @iterator.each do |film_sheet|
      durchlaufene += 1
      film_sheet.trage_agreement_number_ein(alle_film_datas)
      erfolgreiche += 1
    end
    {:durchlaufene => durchlaufene, :erfolgreiche => erfolgreiche}
  end

end

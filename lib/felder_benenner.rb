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
      film_sheet.benenne_vorhandene_felder_entsprechend_zuordnung(zuordnung)
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

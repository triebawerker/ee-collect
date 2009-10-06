# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_steuerung'
require 'film_sheet'

class SheetAusleser
  def initialize(jahr, quartal)
  end

  def each
    Dir["O:/EEAP/REPORTING/Test - DISTRIBUTORS/Xyz_Fixtures/#{@jahr}/#{@jahr} #{@quartal}Q/*.xls*"].each do |pfad|
      puts pfad 
      filmsheet = FilmSheet.new(pfad)
      yield filmsheet
      filmsheet.schliessen
    end
  end

end

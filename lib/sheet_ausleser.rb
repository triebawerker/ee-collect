# To change this template, choose Tools | Templates
# and open the template in the editor.

#require 'excel_steuerung'
require 'film_sheet'
require 'excel_iterator'

class SheetAusleser
  def initialize(licensee, jahr, quartal)
    @licensee = licensee
    @iterator = ExcelIterator.new(licensee, jahr, quartal)
  end

  def each
    @iterator.each do |excel_steuerung|
      filmsheet = FilmSheet.new(excel_steuerung)
      yield filmsheet
      #filmsheet.schliessen
    end
  end

end

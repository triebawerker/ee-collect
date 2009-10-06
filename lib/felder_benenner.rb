# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_iterator'

class FelderBenenner
  def initialize(licensee, jahr, quartal)
    @iterator = ExcelIterator.new(licensee, jahr, quartal)
  end

  def weise_zu(zuordnung)
    @iterator.each do |es|
      zuordnung.each do |name, erkennungszeichen|
        interessante_zeile = if erkennungszeichen[:zeile].is_a?(Integer)
          erkennungszeichen[:zeile]
        else
          zeilen_marke = es.finde_zelle(erkennungszeichen[:zeile], erkennungszeichen)
          zeilen_marke[:zeile]
        end

        interessante_spalte = if erkennungszeichen[:spalte].is_a?(Integer)
          erkennungszeichen[:spalte]
        else
          spalten_marke = es.finde_zelle(erkennungszeichen[:spalte], erkennungszeichen)
          spalten_marke[:spalte]
        end

        es.name_zuweisen(name, interessante_zeile, interessante_spalte)

        raise "Kein Feldinhalt für #{name}" if es.lese_feld(name).nil?
      end
    end
  end
end

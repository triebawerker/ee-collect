# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_iterator'

class FelderBenenner
  def initialize(licensee, jahr, quartal)
    @iterator = ExcelIterator.new(licensee, jahr, quartal)
  end

  def weise_zu(zuordnung)
    @iterator.each do |es|
      next if es.mappe.Name =~ /^ZZZ/
      
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
end

# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'fildat_lesen'

class FilmData 

  attr_reader :title, :minimum_guarantee, :agreement_number, :distributor, :territories

  def initialize(verkauf)
    @title       = verkauf.einkauf.film.Title rescue nil
    @minimum_guarantee          = verkauf.MinimumGurantee.to_f
    @agreement_number = verkauf.IdentNumber
    @distributor = verkauf.adress_typ.name.Lastname
    @territories     = verkauf.länder.map { |land| land.Territory}
  end

  def FilmData.alle
    Verkauf.all.map do |verkauf|
      FilmData.new(verkauf)
    end
  end
end

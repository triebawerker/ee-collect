# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'fildat_lesen'

class FilmData 

  attr_reader :id,:title, :minimum_guarantee, :agreement_number, :distributor, :territories

  def initialize(verkauf)
    @id = verkauf.id_FilmInSale
    @title       = verkauf.einkauf.film.Title rescue nil
    @minimum_guarantee          = verkauf.MinimumGurantee.to_f
    @agreement_number = verkauf.IdentNumber
    @distributor = verkauf.adress_typ.name.Lastname
    #@territories     = verkauf.länder.map { |land| land.Territory}
  end

  def FilmData.alle(options = nil)
    options ||= {}
    options = options.merge(:conditions => "Archive = '0' and SuppressWhyFixed = '0' and id_FilmAcquired IS NOT NULL")
    #options.merge!(:include => [:adress_typ, :einkauf])
    Verkauf.all(options).map do |verkauf|
      FilmData.new(verkauf)
    end
  end
end

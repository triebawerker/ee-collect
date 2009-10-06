# To change this template, choose Tools | Templates
# and open the template in the editor.

puts "Hello World"

$KCODE = "UTF-8"

#require 'win32ole'

#excel = WIN32OLE.new("Excel.Application")

#excel.Visible = true

#sleep 2

require 'active_record'


ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "localhost",
  :database => "ilrm",
  :username => "adminACompany",
  :password => "$*DAdAC2006"
)

ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /(enz)$/, '\1en'
  inflect.singular /(enz)en$/, '\1'

  inflect.plural /(auf)$/, 'äufe'
  inflect.singular /(äufe)$/, 'auf'

  inflect.plural /(and)$/, 'änder'
  inflect.singular /(änder)$/, 'and'
end

class Einkauf < ActiveRecord::Base
  set_table_name "acq_film_acquired"
  set_primary_key "id_FilmAcquired"
  belongs_to :film, :foreign_key => "id_Film"
  has_many :verkäufe, :foreign_key => "id_FilmAcquired"
end

class Film  < ActiveRecord::Base
  set_table_name "film"
  set_primary_key "id_Film"
  has_many :einkäufe, :foreign_key => "id_Film"
end

class Verkauf < ActiveRecord::Base
  set_table_name "sale_film_in_sale"
  set_primary_key "id_FilmInSale"
  belongs_to :einkauf, :foreign_key => "id_FilmAcquired"
  belongs_to :land, :foreign_key => "id_Territory"
end

class Land < ActiveRecord::Base
  set_table_name "territory"
  set_primary_key "id_Territory"
  has_many :verkäufe, :foreign_key => "id_Territory"
end

#FILM
#film = Film.find(:all, :order => "Title", :conditions => "Title = 'SHUTTER ISLAND'")
#film = Film.find('006154de-2a55-4c74-8ab8-23f14c5cbdfe')
#film = Film.find(:first)
#p film.Title
#p film.Director


einkäufe = Einkauf.find(:all, :conditions => "Archive = '0' and SuppressWhyFixed = '0'")

#p einkauf
p einkäufe.map do |einkauf|
  einkauf.MinimumGurantee.to_f
end.inspect



#p einkauf.film.title



#p einkauf.id_FilmAcquired

#id_film_acquired = "000d5d23-065d-4b72-a972-5bae90df213f"

#verkauf = Verkauf.first
#p verkauf

#vk2 = einkauf.verkäufe[1]

#p vk2

#vk2territory = vk2.land

#p film.einkäufe.size



puts "Fertig"
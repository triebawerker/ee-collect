# To change this template, choose Tools | Templates
# and open the template in the editor.



$KCODE = "UTF-8"

#require 'win32ole'

#excel = WIN32OLE.new("Excel.Application")

#excel.Visible = true

#sleep 2

require 'active_record'



ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
#  :host     => "192.168.35.14",
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

  inflect.plural /(p)$/, 'pen'
  inflect.singular /(pen)$/, 'p'
  
  inflect.plural /(me)$/, 'men'
  inflect.singular /(men)$/, 'me'
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
  has_and_belongs_to_many :länder, :join_table => "sale_territory_licence_right",
                          :foreign_key => "id_FilmInSale",
                          :association_foreign_key => "id_Territory",
                          :order => "sale_territory_licence_right.id_Territory",
                          :uniq => true

  belongs_to :adress_typ, :foreign_key => "id_Licensee"
end

class AdressTyp  < ActiveRecord::Base
  set_table_name "address_type"
  set_primary_key "id_AddressType"
  has_many :verkäufe, :foreign_key => "id_Licensee"
  belongs_to :name, :foreign_key => "id_AddressBook"
end

class Name < ActiveRecord::Base
  set_table_name "address_book"
  set_primary_key "id_AddressBook"
  has_one :adress_typ, :foreign_key => "id_AddressBook"

end

class Land < ActiveRecord::Base
  set_table_name "territory"
  set_primary_key "id_Territory"
  has_and_belongs_to_many :verkäufe, :join_table => "sale_territory_licence_right",
                          :association_foreign_key => "id_FilmInSale",
                          :foreign_key => "id_Territory",
                          :order => "sale_territory_licence_right.id_Territory",
                          :uniq => true
end



if __FILE__ == $0 then

  verkäufe = Verkauf.find(:all,
                          :conditions => "Archive = '0' and SuppressWhyFixed = '0' and id_FilmAcquired IS NOT NULL",
                          :limit => 10)

  p verkäufe.map { |verkauf|

    {:Titel => verkauf.einkauf.film.Title,
  #   :MG => einkauf.MinimumGurantee.to_f,
  #   :IndentNumber => einkauf.IdentNumber,
  #   :Distributor => einkauf.typen.namen.LastName,
  #   :Country => einkauf.land.Territory
     }

    }

  p verkäufe.map.size
  puts "Fertig"

end

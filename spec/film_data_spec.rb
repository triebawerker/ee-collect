# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'film_data'
require 'film_sheet'


describe FilmData, "Film: Water" do

  verkauf = Verkauf.find("001f6f9e-5a1d-428a-b8ea-5e7fdc0feaf3")

  before(:each) do
    @film_data = FilmData.new(verkauf)
  end

  it "sollte existieren" do
    @film_data.should_not be_nil
  end

  it "sollte Titel usw. haben" do
    @film_data.title.should == "WATER"
    @film_data.minimum_guarantee.should be_a(Float)
    #@film_data.territories.should == ["Russia"]
    @film_data.distributor.should == "GALA Media & Film International"
    @film_data.agreement_number.should == "AV05-107"
  end

end

describe FilmData, "Film: 2 Days in Paris"  do

  verkauf = Verkauf.find("abb1c2d0-3807-4553-9105-6f6fc78ea3ce")

  before(:each) do
    @film_data = FilmData.new(verkauf)
  end

  it "sollte existieren" do
    @film_data.should_not be_nil
  end

  it "sollte Titel usw. haben" do
    @film_data.title.should == "WATER"
    @film_data.minimum_guarantee.should be_a(Float)
    #@film_data.territories.should == ["Russia"]
    @film_data.distributor.should == "GALA Media & Film International"
    @film_data.agreement_number.should == "AV05-107"
  end

end


limit = 100

describe FilmData, "alle!" do
  before :all do
    @alle_filme = FilmData.alle #(:limit => limit)
  end

#  it "sollte großes Array sein " do
#    @alle_filme.size.should == limit
#  end

  it "sollte vernünftige Werte haben" do
    #p @alle_filme
    f =@alle_filme.first
    f.title.should == "WATER"
    f.minimum_guarantee.should be_a(Float)
    #f.territories.should == ["Slovakia"]
    f.distributor.should == "Markiza - Slovakia, spol. s r.o."
    f.agreement_number.should == "EEAP05-423"
  end

  it "sollte film finden" do
    @fs = FilmSheet.new("#{REPORT_BASIS_PFAD}/ACME/2009/2009 IIQ/2 Days in Paris 06 09.xls")
    agr_number = @fs.agreement_number_aus_filmdata(@alle_filme)
    agr_number.should == "EEAP05-387"
  end

end


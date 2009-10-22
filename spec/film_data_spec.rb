# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'film_data'

describe FilmData do
  
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
    @film_data.territories.should == ["Russia"]
    @film_data.distributor.should == "GALA Media & Film International"
    @film_data.agreement_number.should == "AV05-107"
  end

end


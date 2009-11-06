

require 'film_sheet'

require 'film_data'

describe FilmSheet, "mit Pfad-Initialisierung" do
  before(:each) do
    @fs = FilmSheet.new("#{REPORT_BASIS_PFAD}/ACME/2009/2009 IIQ/2 Days in Paris 06 09.xls")
  end

  after :each do
    @fs.schliessen
  end

  it "sollte licensor_share_total ausgeben können" do
    @fs.licensor_share_total
  end
end


describe FilmSheet, "mit ExcelSteuerung als Initialisierung" do
  before(:each) do
    @excel_steuerung = ExcelSteuerung.new("#{REPORT_BASIS_PFAD}/ACME/2009/2009 IIQ/2 Days in Paris 06 09.xls")
    @fs = FilmSheet.new(@excel_steuerung)
  end

  after :each do
    @fs.schliessen
  end

  it "sollte licensor_share_total ausgeben können" do
    @fs.licensor_share_total.should be_a(Float)
    @fs.title.should == "2 Days in Paris"
    @fs.licensee.should == "ACME"
  end

end


describe FilmSheet, "mit BudFilm Initialisierung" do
  before(:each) do
    @fs = FilmSheet.new("#{REPORT_BASIS_PFAD}/BudFilm/2009/2009 IIQ/2 DaysInParis 06 09.xls")
  end

  after :each do
    @fs.schliessen
  end

  it "sollte licensor_share_total ausgeben können" do
    @fs.licensor_share_total
  end

  it "sollte licensee matchen" do
    film_data = FilmData.alle #(:limit => limit)
    agr_num = @fs.agreement_number_aus_filmdata(film_data)
    agr_num.should be_a String
  end
end



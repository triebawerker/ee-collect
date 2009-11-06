

require 'film_sheet'

require 'film_data'


alle_film_datas = FilmData.alle #(:limit => limit)

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

  it "sollte aus DB raussuchen können" do
    agr_num = @fs.agreement_number_aus_filmdata(alle_film_datas)
    agr_num.should be_a(String)
  end

  it "sollte aus DB raussuchen können" do
    @fs.excel_steuerung.mappe.Names.Item("agreement_number").Delete
    proc { @fs.excel_steuerung.lese_feld("agreement_number") }.should raise_error
    #agr_num.should be_a(String)
    @fs.trage_agreement_number_ein(alle_film_datas)
    agr_num = @fs.excel_steuerung.lese_feld("agreement_number")
    agr_num.should be_a(String)
  end
end


if false #describe FilmSheet, "mit ExcelSteuerung als Initialisierung" do
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

  it "sollte excel_steuerung zurückgeben" do
    @fs.excel_steuerung.should be_a(ExcelSteuerung)
  end

end


describe FilmSheet, "mit BudFilm Initialisierung" do
  before(:each) do
    @fs = FilmSheet.new("#{REPORT_BASIS_PFAD}/BudFilm/2009/2009 IIQ/2 DaysInParis 06 09.xls")
  end

  after :each do
    @fs.schliessen
  end

  it "sollte licensee matchen" do
    @fs.benenne_vorhandene_felder_entsprechend_zuordnung(FILMSHEET_NAMEN_ERKENNUNGSZEICHEN)
    agr_num = @fs.agreement_number_aus_filmdata(alle_film_datas)
    agr_num.should be_a(String)
  end
end



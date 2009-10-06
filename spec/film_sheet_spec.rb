

require 'film_sheet'

describe FilmSheet do
  before(:each) do
    @fs = FilmSheet.new("O:/EEAP/REPORTING/Test - DISTRIBUTORS/Xyz_Fixtures/2009/2009 IIQ/2 Days in Paris 06 09.xls")
  end

  it "sollte licensor_share_total ausgeben können" do
    @fs.licensor_share_total
  end
end


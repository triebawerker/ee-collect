# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'sheet_ausleser'

describe SheetAusleser do
  before(:each) do
    
  end

  it "sollte existieren" do
    jahr = 2009
    quartal = 2
    sheet_ausleser1 = SheetAusleser.new(jahr, quartal)
    sheet_ausleser1.should_not be_nil
  end

  it "sollte summieren" do
    jahr = 2009
    quartal = 2
    sheet_ausleser1 = SheetAusleser.new(jahr, quartal)

    licensor_share_total_summe = 0
    sheet_ausleser1.each do |filmsheet|
      licensor_share_total_summe += filmsheet.licensor_share_total 
    end
    licensor_share_total_summe.should == 33
  end

end


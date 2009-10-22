# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'sheet_ausleser'

describe SheetAusleser do
  before(:all) do
    @licensee = "ACME"
    @jahr = 2009
    @quartal = 2
  end

  it "sollte existieren" do
    
    sheet_ausleser1 = SheetAusleser.new(@licensee, @jahr, @quartal)
    sheet_ausleser1.should_not be_nil
  end

  it "sollte summieren" do

    sheet_ausleser1 = SheetAusleser.new(@licensee, @jahr, @quartal)

    licensor_share_total_summe = 0
    sheet_ausleser1.each do |filmsheet|
      licensor_share_total_summe += filmsheet.licensor_share_total
    end
    licensor_share_total_summe.should == 33
  end

end


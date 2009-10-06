# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'excel_iterator'

describe ExcelIterator do
  before(:each) do
    licensee, jahr, quartal = "Xyz_Fixtures", 2009, 2
    @excel_iterierer = ExcelIterator.new(licensee, jahr, quartal)
  end

  it "sollte alle einmal durchlaufen" do
    z = 0
    @excel_iterierer.each do |excel_steuerung|
      puts excel_steuerung.mappe.Name
      z += 1
    end
    z.should == 78
  end
end


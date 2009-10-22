# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'do_felder_benenner'

describe DoFelderBenenner, " für Agreement Number" do
  licensees = Dir.entries(REPORT_BASIS_PFAD).select {|dir_name| dir_name !~ /^(\.|ZZZ)/ and dir_name !~ /\.xls.+$/}
  jahr = 2009
  quartal = "II"

  i = 0
  licensees.each do |licensee|
    describe "mit #{licensee}" do
      @felder_benenner = FelderBenenner.new(licensee, jahr, quartal)
      @felder_benenner.neue_felder_benennen

      i += 1
      break if i > 10
    end
  end


end



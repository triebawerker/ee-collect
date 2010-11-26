# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'do_felder_benenner'
require 'utilities'

describe DoFelderBenenner, " für Agreement Number" do
#  licensees = ["Sunny"]
  licensees = alle_licensees(REPORT_BASIS_PFAD)
  jahr = 2009
  quartal = "II"

  i = 0

  licensees.each do |licensee|
    describe "mit #{licensee}" do
      @felder_benenner = FelderBenenner.new(licensee, jahr, quartal)
      @felder_benenner.bestehende_felder_benennen(FILMSHEET_NAMEN_ERKENNUNGSZEICHEN)
      p @felder_benenner.neue_felder_benennen

      i += 1
      break if i > 10
    end
  end


end



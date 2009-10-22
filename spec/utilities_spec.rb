# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'utilities'


describe Regexp, "mit title-matcher" do
  describe Regexp, "für 'abc 2'" do
    before(:each) do
      @tm1 = Regexp.title_matcher("abc 2")
    end

    positive = [
      "ABC 2",
      "ABC II",
      "ABC  2",
      "ABC \n 2"
    ]

    positive.each do |str|
      it "should match #{str}" do
        @tm1.should =~ str
      end
    end

    negative = [
      "ABC III",
      "abc 3",
      "abcii"
    ]
    negative.each do |str|
      it "should not match #{str}" do
        @tm1.should_not =~ str
      end
    end
  end

  it "should match vs." do
    Regexp.title_matcher("a vs. b").should =~ "a vs b"
    Regexp.title_matcher("a vs b").should =~ "a vs b"
  end
  
  describe Regexp, "für 'armour'" do
    before(:each) do
      @tm1 = Regexp.title_matcher("armour")
    end

    positive = [
      "armor",
      "armour"
    ]

    positive.each do |str|
      it "should match #{str}" do
        @tm1.should =~ str
      end
    end

    negative = [
    ]
    negative.each do |str|
      it "should not match #{str}" do
        @tm1.should_not =~ str
      end
    end

  end
end
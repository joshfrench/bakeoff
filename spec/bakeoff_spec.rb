require File.join(File.dirname(__FILE__), 'spec_helper')

describe Baked do
  include Rack::Test::Methods

  describe "POST /vote" do
    it "should create a new ballot" do
      post "/vote", :ballot => {:taste => { "Cookies" => "0", "Muffins" => "2", "Brownies" => "1"}}
      Ballot.count.should == 1
      ballot = Ballot.first
      ballot.taste.should == %w(Cookies Brownies Muffins)
    end
  end
end

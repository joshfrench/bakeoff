require File.join(File.dirname(__FILE__), 'spec_helper')

describe Ballot do
  include Rack::Test::Methods

  describe "#from_hash" do
    it "should order hash keys" do
      ballot = Ballot.new.from_hash :taste => {'Alpha' => '0', 'Gamma' => '2', 'Beta' => "1"}
      ballot.taste.should == %w(Alpha Beta Gamma)
    end

    it "should overwrite existing values" do
      ballot = Ballot.new
      ballot.taste = %w(A B C D)
      ballot.from_hash :taste => {'A' => 2, 'C' => 0, 'B' => 1}
      ballot.taste.should == %w(C B A)
    end
  end

  describe ".overall" do
    it "should show the overall winners" do
      Factory(:ballot, :taste => %w(Cookies Muffins Brownies))
      Factory(:ballot, :taste => %w(Cookies Muffins Brownies))
      Factory(:ballot, :presentation => %w(Muffins Cookies Brownies), :taste => [])
      Factory(:ballot, :creativity => %w(Muffins Cookies Brownies), :taste => [])
      Factory(:ballot, :creativity => %w(Muffins Brownies Cookies), :taste => [])
      Ballot.overall.should eql %w(Muffins Cookies Brownies)
    end
  end

  describe ".category" do
    it "should return a set of results scoped by category" do
      Factory(:ballot, :taste => %w(Cookies Muffins Brownies))
      Factory(:ballot, :taste => %w(Cookies Muffins Brownies))
      Factory(:ballot, :taste => %w(Cookies Brownies Muffins))
      Ballot.category(:taste).should eql %w(Cookies Muffins Brownies)
    end
  end
end

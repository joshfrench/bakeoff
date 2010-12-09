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
end

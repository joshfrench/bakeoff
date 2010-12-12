require File.join(File.dirname(__FILE__), 'spec_helper')

describe Ballot do
  include Rack::Test::Methods

  before do
    @alpha = Factory(:entry)
    @beta = Factory(:entry)
    @gamma = Factory(:entry)
  end

  describe ".find_or_initialize_by_name" do
    it "should be case insensitive" do
      ballot = Factory(:ballot, :name => 'josh')
      new = Ballot.find_or_initialize_by_name('Josh')
      new.should == ballot
    end
  end


  describe "#from_hash" do
    it "should order hash keys" do
      ballot = Ballot.new.from_hash 'name' => 'Josh', 'taste' => {@alpha.id => '0', @gamma.id => '2', @beta.id => "1"}
      ballot.taste.should == [@alpha.id, @beta.id, @gamma.id]
    end

    it "should overwrite existing values" do
      ballot = Ballot.new
      ballot = Ballot.new.from_hash 'name' => 'Josh', 'taste' => {@alpha.id => '0', @gamma.id => '2', @beta.id => "1"}
      ballot.from_hash 'name' => 'Josh', 'taste' => {@alpha.id => 2, @beta.id => 0, @gamma.id => 1}
      ballot.taste.should == [@beta.id, @gamma.id, @alpha.id]
    end
  end

  describe ".overall" do
    it "should show the overall winners" do
      Ballot.destroy_all
      Factory(:ballot, 'taste' => [@alpha.id, @beta.id, @gamma.id])
      Factory(:ballot, 'taste' => [@alpha.id, @beta.id, @gamma.id])
      Factory(:ballot, 'presentation' => [@beta.id, @alpha.id, @gamma.id], :taste => [])
      Factory(:ballot, 'creativity' => [@beta.id, @alpha.id, @gamma.id], :taste => [])
      Factory(:ballot, 'creativity' => [@beta.id, @alpha.id, @gamma.id], :taste => [])
      Ballot.overall.should eql [@beta, @alpha, @gamma]
    end
  end

  describe ".category" do
    it "should return a set of results scoped by category" do
      Factory(:ballot, :taste => [@alpha.id, @beta.id, @gamma.id])
      Factory(:ballot, :taste => [@alpha.id, @beta.id, @gamma.id])
      Factory(:ballot, :taste => [@alpha.id, @beta.id, @gamma.id])
      Ballot.category(:taste).should eql [@alpha, @beta, @gamma]
    end
  end

end

require File.join(File.dirname(__FILE__), 'spec_helper')

describe Entry do

  describe ".slug" do
    it "should make a basic slug for DOM use" do
      entry = Entry.new
      entry.name = " Auntie Entity's       A++ Thunder-Snaps "
      entry.slug.should == 'auntie_entitys_a_thundersnaps'
    end
  end

end

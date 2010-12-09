class Ballot
  include Mongoid::Document
  field :ip
  field :taste, :type => Array, :default => []
  field :presentation, :type => Array, :default => []
  field :creativity, :type => Array, :default => []

  validates_presence_of :ip
  validates_uniqueness_of :ip, :case_sensitive => false

  def from_hash(hash)
    hash.each_pair do |category,votes|
      votes.each_pair do |entry,rank|
        self[category][rank.to_i] = entry
      end
    end
    self
  end
end

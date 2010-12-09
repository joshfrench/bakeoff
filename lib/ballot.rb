class Ballot
  include Mongoid::Document
  field :taste, :type => Array, :default => []
  field :presentation, :type => Array, :default => []
  field :creativity, :type => Array, :default => []

  def self.from_hash(hash)
    ballot = self.new
    hash.each_pair do |category,votes|
      array = []
      votes.each_pair do |entry,rank|
        array[rank.to_i] = entry
      end
      ballot[category] = array
    end
    ballot
  end
end

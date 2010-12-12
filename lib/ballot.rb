require 'runoff'

class Ballot
  include Mongoid::Document
  field :ip
  field :name
  field :taste, :type => Array, :default => []
  field :presentation, :type => Array, :default => []
  field :creativity, :type => Array, :default => []

  validates_presence_of :ip
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  def from_hash(hash)
    self.name = hash.delete('name').downcase
    hash.each_pair do |category,votes|
      self[category] = []
      votes.each_pair do |entry,rank|
        self[category][rank.to_i] = entry
      end
    end
    self
  end

  def self.find_or_initialize_by_name(name)
    self.find_or_initialize_by(:name => name.downcase)
  end

  def self.category(category)
    ballots = self.all.map(&category)
    self.rankings(ballots)
  end

  def self.overall
    ballots = self.all.map(&:taste)
    ballots.concat self.all.map(&:creativity) 
    ballots.concat self.all.map(&:presentation)
    self.rankings(ballots)
  end

  private

    def self.rankings(ballots)
      ballots.reject! &:empty?
      winners = []
      return winners if ballots.compact.empty?
      3.times do
        ballots.each { |b| b.delete winners.last }
        winners << InstantRunoffVote.new(ballots).result.winner
      end
      # Mongoid criteria not respecting array order?
      winners.map {|w| Entry.find(w) }
    end
end

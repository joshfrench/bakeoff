require 'runoff'

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
      self[category] = []
      votes.each_pair do |entry,rank|
        self[category][rank.to_i] = entry
      end
    end
    self
  end

  def self.category(category)
    ballots = self.all.map(&category)
    self.rankings(ballots)
  end

  def self.overall
    ballots = [*self.all.map(&:taste), *self.all.map(&:creativity), *self.all.map(&:presentation)]
    self.rankings(ballots)
  end

  private

    def self.rankings(ballots)
      ballots.reject! &:empty?
      winners = []
      ballots.flatten.uniq.size.times do
        ballots.each { |b| b.delete winners.last }
        winners << InstantRunoffVote.new(ballots).result.winner
      end
      winners
    end
end

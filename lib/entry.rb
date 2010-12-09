require 'mongoid'

class Entry
  include Mongoid::Document
  field :name
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
end

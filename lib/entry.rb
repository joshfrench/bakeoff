require 'upload'

class Entry
  require 'carrierwave/orm/mongoid'
  include Mongoid::Document
  field :name
  mount_uploader :image, Upload
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
end

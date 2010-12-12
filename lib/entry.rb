require 'upload'

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  mount_uploader :image, Upload
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  def <=> other
    self.name <=> other.name
  end

  def slug
    name.strip.downcase.gsub(/[^\w\s]+/, '').gsub(/\s+/,'_')
  end

end

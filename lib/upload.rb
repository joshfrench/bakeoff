require 'carrierwave'
require 'carrierwave/processing/rmagick'

class Upload < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process :resize_to_fill => [80, 80]

  def store_dir
    "#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end

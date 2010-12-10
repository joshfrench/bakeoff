class Upload < CarrierWave::Uploader::Base
  def store_dir
    "#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end

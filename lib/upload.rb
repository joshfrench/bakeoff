class Upload < CarrierWave::Uploader::Base
  def store_dir
    'gridfs'
  end

  def filename
    model.id.to_s
  end

  def cache_dir
    ENV['TMPDIR'] || File.join(File.dirname(__FILE__), 'tmp')
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end

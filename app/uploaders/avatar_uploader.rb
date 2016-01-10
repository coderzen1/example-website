class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :small do
    process resize_to_fit: [300, 300]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end

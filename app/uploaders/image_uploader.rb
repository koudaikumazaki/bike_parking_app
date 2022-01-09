class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.development? || Rails.env.test?
    storage :file
  else
    storage :fog
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*_args)
    "/images/#{[version_name, 'default.png'].compact.join('_')}"
  end

  process resize_to_fill: [500, 500, "Center"]

  version :thumb do
    process resize_to_fill: [250, 250, "Center"]
  end
end

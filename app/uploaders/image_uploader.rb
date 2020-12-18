class ImageUploader < CarrierWave::Uploader::Base

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def size_range
    0..5.megabytes
  end
  
  # def default_url(*args)
  #   For Rails 3.1+ asset pipeline compatibility:
  #   ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

    process convert: "jpg"
    process resize_to_limit: [200, 300]

      version :thumb do
    process resize_to_fit: [100, 100]
  end

  # ファイル名の拡張子を jpg に変更
  def filename
    super.chomp(File.extname(super)) + ".jpg" if original_filename.present?
  end

    include CarrierWave::MiniMagick

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end

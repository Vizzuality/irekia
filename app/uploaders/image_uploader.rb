# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  include CarrierWave::MiniMagick

  def self.cache_from_io!(io_string, file_or_name)
    uploader = ImageUploader.new
    tempfile = if file_or_name.is_a?(String)
      tempfile = Tempfile.new(file_or_name)
      tempfile.write io_string.read.force_encoding('UTF-8')
      tempfile
    else
      file_or_name.tempfile
    end
    uploader.cache!(tempfile)
    tempfile.close
    tempfile.unlink
    uploader
  end

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :resize_to_fill => [280, 280]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [65, 65]
  end

  version :thumb_big do
    process :resize_to_fill => [280, 280]
  end

  version :list_element do
    process :resize_to_fit => [121, 90]
  end

  version :original do
  end

  version :content do
    process :contents_size
  end

  def contents_size
    manipulate! do |img|
      img.resize "#{608}x#{1000}" if img[:width] > 608
      img = yield(img) if block_given?
      img
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end

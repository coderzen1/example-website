if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog

    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Rails.application.secrets.s3_access_key_id,
      :aws_secret_access_key  => Rails.application.secrets.s3_secret_access_key,
      :region                 => 'us-west-2'
    }
    config.fog_directory  = Rails.application.secrets.s3_bucket
    config.fog_public     = false                                        # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} # optional, defaults to {}
  end
end

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory = 'for-my-postforio'
    config.asset_host = 'https://s3.amazonaws.com/for-my-postforio'
    # NOTE: AWS側の設定を変えなくても、この１行の設定でアップロードできた
    config.fog_public = false # ←コレ
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.credentials.aws[:access_key_id],
      # aws_access_key_id: ENV['AWS_ACCESS_KEY'],
      aws_secret_access_key: Rails.application.credentials.aws[:secret_access_key],
      # aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1'
      # path_style: true
    }
  else
    config.storage :file
  end
end

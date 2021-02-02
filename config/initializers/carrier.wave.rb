# unless Rails.env.development? || Rails.env.test?
#   CarrierWave.configure do |config|
#     config.fog_credentials = {
#       provider: 'AWS',
#       aws_access_key_id: 'AKIAWDLJJRM6HVKLWURN',
#       aws_secret_access_key: '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',
#       region: 'ap-northeast-1'
#     }

#     config.fog_directory  = 'for-my-postforio'
#     config.cache_storage = :fog
#   end
# end

# require 'carrierwave/storage/abstract'
# require 'carrierwave/storage/file'
# require 'carrierwave/storage/fog'

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
      aws_access_key_id: ENV['AWS_ACCESS_KEY'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1'
      # path_style: true
    }
  else
    config.storage :file
  end
end

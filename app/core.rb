module RabbitHouse
  class Core < Grape::API
    version 'v1', using: :header, vendor: 'RabbitHouse'
    format :json
    prefix :api
    logger $logger

    mount RabbitHouse::UploadAPI
    mount RabbitHouse::BasicAPI
    mount RabbitHouse::SkillAPI
    mount RabbitHouse::RareAPI
  end
end

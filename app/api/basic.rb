module RabbitHouse
  class BasicAPI < Grape::API
    resource :basic do
      params do
        requires :uuid, type: String, desc: 'Unique User ID'
      end
      get do
        uuid = params[:uuid]
        error! ['Unknown UID'], 404 if uuid.size != 16

        fs = $redis.get(uuid)
        error! ['Unknown UID'], 404 if fs.nil?
        YAML.load(fs).map { |fs| fs.to_hash }
      end
    end
  end
end

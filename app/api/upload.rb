module RabbitHouse
  class UploadAPI < Grape::API
    resource :upload do
      desc 'Upload follower data'
      params do
        requires :content, type: String, desc: 'CSV Content'
      end
      post do
        csv = params[:content]
        error! 'Invalid input', 404 if csv.size < 2
        header = csv.lines[0].strip
        fs = csv.lines[1..-1].map do |l|
          Follower.new l.strip, header
        end
        uuid = SecureRandom.hex 8
        $redis.setex uuid, 86400, YAML.dump(fs)
        uuid
      end
    end
  end
end

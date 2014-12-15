module RabbitHouse
  class T630API < Grape::API
    helpers do
      include Prob
    end
    resource :t630 do
      params do
        requires :uuid, type: String, desc: 'Unique User ID'
      end
      get do
        skills = ["1268", "0166", "0258", "0117", "1468", "0025", "0358", "0036", "0268", "0145", "3458"]

        uuid = params[:uuid]
        error! ['Unknown UID'], 404 if uuid.size != 16

        fs = $redis.get(uuid)
        error! ['Unknown UID'], 404 if fs.nil?
        $perm[:t630] ||= permutation skills
        perm = $perm[:t630]

        fs_data = YAML.load(fs)
        people_index = convert_follower_skills fs_data
        skills = check_coverage perm, *people_index

        # Return Purple Followers; Green Followers; Skill Demands
        people = fs_data.map(&:to_hash).partition { |f| f[:color] == 4 }
        people + skills
      end
    end
  end
end

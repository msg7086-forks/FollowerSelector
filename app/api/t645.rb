module RabbitHouse
  class T645API < Grape::API
    helpers do
      include Prob
    end
    resource :t645 do
      params do
        requires :uuid, type: String, desc: 'Unique User ID'
      end
      get do
        skills = ['012568', '334578', '002467', '015668']

        uuid = params[:uuid]
        error! ['Unknown UID'], 404 if uuid.size != 16

        fs = $redis.get(uuid)
        error! ['Unknown UID'], 404 if fs.nil?
        $perm[:t645] ||= permutation skills
        perm = $perm[:t645]
        
        fs_data = YAML.load(fs)
        people_index = convert_follower_skills fs_data
        skills = check_coverage perm, *people_index

        # Return Purple Followers; Green Followers; Skill Demands
        people = fs_data.map(&:to_hash).partition { |f| f[:color] == 4 }
        people <<= skills
        people
      end
    end
  end
end

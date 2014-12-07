module RabbitHouse
  class SkillAPI < Grape::API
    resource :skill do
      params do
        requires :uuid, type: String, desc: 'Unique User ID'
      end
      get do
        uuid = params[:uuid]
        error! ['Unknown UID'], 404 if uuid.size != 16

        fs = $redis.get(uuid)
        error! ['Unknown UID'], 404 if fs.nil?
        skill_groups = Hash.new {[]}
        YAML.load(fs).each do |f|
          f.skills.each do |sk|
            skill_groups[sk] <<= f.to_hash
          end
        end
        skill_groups
      end
    end
  end
end

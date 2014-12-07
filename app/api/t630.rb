module RabbitHouse
  class T630API < Grape::API
    helpers do
      def permutation
        task630 = ['012568', '334578', '002467', '015668']
        task630.map do |t|
          perm = t.chars.permutation.select do |p|
            p[0] < p[1] && p[2] < p[3] && p[4] < p[5] &&
            p[0] <= p[2] && p[2] <= p[4] &&
            (p[0] != p[2] || p[1] <= p[3]) &&
            (p[2] != p[4] || p[3] <= p[5])
          end
          p perm.map(&:join).uniq
        end
      end
    end
    resource :t630 do
      params do
        requires :uuid, type: String, desc: 'Unique User ID'
      end
      get do
        @skills = ['限时战斗','强力法术','重击','群体伤害','爪牙围攻','危险区域','致命爪牙','魔法减益','野生怪物入侵']

        uuid = params[:uuid]
        error! ['Unknown UID'], 404 if uuid.size != 16

        fs = $redis.get(uuid)
        error! ['Unknown UID'], 404 if fs.nil?
        $perm ||= permutation
        
        people4_index = Hash.new {[]}
        people2_index = Hash.new {[]}
        skill_index = Array.new(9) { Array.new(9, 0) }
        fs_data = YAML.load(fs)
        fs_data.each do |f|
          key = f.skills.map { |sk| @skills.index(sk).to_s }.sort
          if f.skills.size == 2
            people4_index[key.join] <<= f
          else
            people2_index[key[0]] <<= f
          end
        end
        # Now check coverage
        $perm.each do |t|
          t.each do |p|
            p.chars.each_slice(2).map(&:join).each do |key|
              # Check if any purple followers cover the task
              if people4_index[key].size > 0
                # Yay!
                people4_index[key].each { |ppl| ppl.coverage += 1.0 / t.size }
                # No more check on this combination
                next
              end
              (0..1).to_a.each do |i|
                key1 = key[i]
                key2 = key[1-i]
                people2_index[key1].each { |ppl| ppl.possible_coverage(@skills[key2.to_i], 1.0 / t.size) }
                skill_index[key1.to_i][key2.to_i] += 1
              end
            end
          end
        end
        # Return Purple Followers; Green Followers; Skill Demands
        people = fs_data.map(&:to_hash).partition { |f| f[:color] == 4 }
        skills = {}
        skill_index.each_with_index do |v, k|
          sk = []
          v.each_with_index { |item, i| sk <<= [@skills[i], item] if item > 0}
          skills[@skills[k]] = sk.sort_by(&:last).reverse
        end
        people <<= skills
        people
      end
    end
  end
end

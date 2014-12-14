module Prob
  def permutation skills
    skills.map do |t|
      perm = t.chars.permutation.select do |p|
        p[0] < p[1] && p[2] < p[3] &&
        p[0] <= p[2] &&
        (p[0] != p[2] || p[1] <= p[3])
      end
      perm = perm.select do |p|
        p[4] < p[5] && p[2] <= p[4] && (p[2] != p[4] || p[3] <= p[5])
      end if t.size > 5
      perm.map(&:join).uniq
    end
  end

  def convert_follower_skills fs_data
    people4_index = Hash.new {[]}
    people2_index = Hash.new {[]}
    fs_data.each do |f|
      key = f.skills.map { |sk| Skill.find(sk).to_s }.sort
      if f.skills.size == 2
        people4_index[key.join] <<= f
      else
        people2_index[key[0]] <<= f
      end
    end
    [people4_index, people2_index]
  end
  def check_coverage perm, people4_index, people2_index
    # Now check coverage
    skill_index = Array.new(9) { Array.new(9, 0) }
    perm.each do |t|
      t.each do |p|
        p.chars.each_slice(2).map(&:join).each do |key|
          # Check if any purple followers cover the task
          if people4_index[key].size > 0
            # Yay!
            people4_index[key].each { |ppl| ppl.coverage += 2.0 / t.size }
            # No more check on this combination
            next
          end
          (0..1).to_a.each do |i|
            key1 = key[i]
            key2 = key[1-i]
            people2_index[key1].each { |ppl| ppl.possible_coverage(key2.to_i, 1.0 / t.size) }
            skill_index[key1.to_i][key2.to_i] += 1
          end
        end
      end
    end
    skills = {}
    skill_index.each_with_index do |v, k|
      sk = []
      v.each_with_index { |item, i| sk <<= [Skill.cn(i), item] if item > 0}
      skills[Skill.cn(k)] = sk.sort_by(&:last).reverse
    end
    skills
  end
end
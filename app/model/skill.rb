class Skill
  @@cn = ['限时战斗','强力法术','重击','群体伤害','爪牙围攻','危险区域','致命爪牙','魔法减益','野生怪物入侵']
  @@en = ['Timed Battle','Powerful Spell','Massive Strike','Group Damage','Minion Swarms','Danger Zones','Deadly Minions','Magic Debuff','Wild Aggression']

  def self.find condition
    return condition if condition.is_a? Integer
    idx = @@cn.index condition
    return idx if !idx.nil?
    idx = @@en.index condition
    return idx if !idx.nil?
    return nil
  end
  def self.find_new condition
    id = Skill.find condition
    return Skill.new id if !id.nil?
    return nil
  end
  def initialize id
    @id = id
  end
  def cn
    @@cn[@id]
  end
  def en
    @@en[@id]
  end
  def self.cn id
    Array === id ? id.map { |i| @@cn[i] } : @@cn[id]
  end
end
class Follower
  attr_accessor :name, :klass, :color, :level, :equipment, :enabled, :skills, :traits, :coverage
  def initialize csv
    self.name, self.klass, c, l, eq, en, s1, s2, t1, t2, t3 = csv.strip.split ','
    self.skills = [s1, s2] - [nil, '']
    self.traits = [t1, t2, t3] - [nil, '']
    self.enabled = en.empty? # empty equals enabled
    self.color = c.to_i
    self.level = l.to_i
    self.equipment = eq.to_i
    self.coverage = 0.0
  end
  def to_s
    "#{name} (#{klass}) Lv #{level} (#{skills}) (#{traits})"
  end
  def possible_coverage skill, cov
    # Test klass before add coverage
    self.coverage += cov if Follower.cover? self.klass, Skill.cn(skill)[0]
  end
  def self.cover? klass, skill
    if klass['死亡骑士']
      return true if '爪强限野魔'[skill] && klass['冰']
      return true if '爪强限野重'[skill] && !klass['冰']
    elsif klass['德鲁伊']
      return true if '致群魔爪限'[skill] && klass['恢复']
      return true if '危致重限野'[skill] && klass['守护']
      return true if '危致爪限'[skill] && klass['平衡']
      return true if '危重限野'[skill] && klass['野性']
    elsif klass['猎人']
      return true if '危致爪限'[skill]
      return true if '野'[skill] && klass['兽']
      return true if '重'[skill] && klass['存']
      return true if '强'[skill] && klass['射']
    elsif klass['法师']
      return true if '致强限'[skill]
      return true if '危'[skill] && klass['奥']
      return true if '危爪'[skill] && klass['火']
      return true if '重爪'[skill] && klass['冰']
    elsif klass['武僧']
      return true if '危致群重野'[skill] && klass['酒仙']
      return true if '危致强限野'[skill] && klass['踏风']
      return true if '危群魔强限'[skill] && klass['织雾']
    elsif klass['圣骑士']
      return true if '致重强限'[skill] && klass['惩戒']
      return true if '致魔重爪强野'[skill] && klass['防护']
      return true if '致群魔强限'[skill] && klass['神圣']
    elsif klass['牧师']
      return true if '危致群魔限'[skill] && klass['戒律']
      return true if '危群魔爪限'[skill] && klass['神圣']
      return true if '危致魔爪限'[skill] && klass['暗影']
    elsif klass['潜行者']
      return true if '危致重强限'[skill] && klass['刺杀']
      return true if '危致爪强限'[skill] && klass['战斗']
      return true if '危致重爪强'[skill] && klass['敏锐']
    elsif klass['萨满']
      return true if '致群爪强限'[skill] && klass['元素']
      return true if '危致群爪限'[skill] && klass['增强']
      return true if '群魔爪强限'[skill] && klass['恢复']
    elsif klass['术士']
      return true if '致魔强限'[skill] && klass['痛苦']
      return true if '致群爪强限'[skill] && klass['毁灭']
      return true if '重爪强限'[skill] && klass['恶魔']
    elsif klass['战士']
      return true if '危爪强'[skill]
      return true if '限野'[skill] && klass['武']
      return true if '重限'[skill] && klass['狂']
      return true if '重野'[skill] && klass['防']
    end
    return false
  end
  def to_hash
    {
      name: name,
      klass: klass,
      color: color,
      level: level,
      equipment: equipment,
      enabled: enabled,
      skills: skills,
      traits: traits,
      coverage: coverage.round(2)
    }
  end
end

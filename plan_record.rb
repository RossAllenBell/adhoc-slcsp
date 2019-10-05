class PlanRecord
  attr_accessor :plan_id, :state, :metal_level, :rate, :rate_area

  module MetalLevels
    Silver = 'Silver'
  end

  def initialize(plan_id:, state:, metal_level:, rate:, rate_area:)
    self.plan_id = plan_id
    self.state = state
    self.metal_level = metal_level
    self.rate = rate
    self.rate_area = rate_area
  end

  def plan_area
    return "#{self.state} #{self.rate_area}"
  end

end

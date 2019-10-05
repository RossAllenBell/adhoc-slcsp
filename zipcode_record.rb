class ZipcodeRecord
  attr_accessor :zipcode, :state, :county_code, :name, :rate_area

  def initialize(zipcode:, state:, county_code:, name:, rate_area:)
    self.zipcode = zipcode
    self.state = state
    self.county_code = county_code
    self.name = name
    self.rate_area = rate_area
  end

  def plan_area
    return "#{self.state} #{self.rate_area}"
  end

end

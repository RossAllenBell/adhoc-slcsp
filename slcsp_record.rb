class SlcspRecord
  attr_accessor :zipcode, :rate

  def initialize(zipcode:, rate: nil)
    self.zipcode = zipcode
    self.rate = rate
  end

  def set_rate!(zip_records:, plan_records:)
    applicable_zipcode_records = zip_records.select do |zr|
      zr.zipcode == self.zipcode
    end

    zipcodes_to_rate_areas = {}
    applicable_zipcode_records.each do |zr|
      zipcodes_to_rate_areas[zr.zipcode] ||= []
      zipcodes_to_rate_areas[zr.zipcode] << zr.plan_area
      zipcodes_to_rate_areas[zr.zipcode] = zipcodes_to_rate_areas[zr.zipcode].uniq
    end

    applicable_zipcode_records = applicable_zipcode_records.select do |zr|
      zipcodes_to_rate_areas[zr.zipcode].size == 1
    end

    plan_areas = applicable_zipcode_records.map(&:plan_area)

    applicable_plan_records = plan_records.select do |pr|
      pr.metal_level == PlanRecord::MetalLevels::Silver
    end.select do |pr|
      plan_areas.include?(pr.plan_area)
    end

    rates = applicable_plan_records.map(&:rate)

    self.rate = rates.uniq[1]
  end

  def csv_data
    output_rate = ''

    if self.rate.to_s.length > 0 && self.rate.to_f > 0
      output_rate = '%.2f' % self.rate.to_f
    end

    return "#{self.zipcode},#{output_rate}"
  end
end

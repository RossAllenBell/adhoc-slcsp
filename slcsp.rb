require 'csv'

require './zipcode_record'
require './plan_record'
require './slcsp_record'

def main
  zips_filename = ARGV[0] || fail('expecting: [zips filename] [plans filename] [slcsp filename]')
  plans_filename = ARGV[1] || fail('expecting: [zips filename] [plans filename] [slcsp filename]')
  slcsp_filename = ARGV[2] || fail('expecting: [zips filename] [plans filename] [slcsp filename]')

  zip_records = CSV.parse(
    File.read(zips_filename),
    headers: :first_row,
    header_converters: :symbol,
    skip_blanks: true,
  ).map(&:to_h).map do |row|
    ZipcodeRecord.new(**row)
  end

  plan_records = CSV.parse(
    File.read(plans_filename),
    headers: :first_row,
    header_converters: :symbol,
    skip_blanks: true,
  ).map(&:to_h).map do |row|
    PlanRecord.new(**row)
  end

  slcsp_records = CSV.parse(
    File.read(slcsp_filename),
    headers: :first_row,
    header_converters: :symbol,
    skip_blanks: true,
  ).map(&:to_h).map do |row|
    SlcspRecord.new(**row)
  end

  puts 'zipcode,rate'
  slcsp_records.each do |slcsp_record|
    slcsp_record.set_rate!(
      zip_records: zip_records,
      plan_records: plan_records,
    )

    puts slcsp_record.csv_data
  end
end

main

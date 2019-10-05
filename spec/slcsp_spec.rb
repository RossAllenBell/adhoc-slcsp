require './zipcode_record'
require './plan_record'
require './slcsp_record'

RSpec.describe :slcsp_record do

  describe :csv_data do

    it 'produces correct csv data' do
      expect(SlcspRecord.new(zipcode: '12345', rate: '123.45').csv_data).to eql('12345,123.45')
    end

    it 'formats the rate to two decimal places' do
      expect(SlcspRecord.new(zipcode: '12345', rate: '123').csv_data).to eql('12345,123.00')
    end

    it 'omits the rate if nil' do
      expect(SlcspRecord.new(zipcode: '12345', rate: nil).csv_data).to eql('12345,')
    end

    it 'omits the rate if 0' do
      expect(SlcspRecord.new(zipcode: '12345', rate: '0').csv_data).to eql('12345,')
    end

    it 'omits the rate if an empty string' do
      expect(SlcspRecord.new(zipcode: '12345', rate: '').csv_data).to eql('12345,')
    end

  end

  describe :set_rate! do

    let(:alabama_code){'AL'}
    let(:zipcode_12345){'12345'}
    let(:county_code_01001){'01001'}
    let(:county_code_01003){'01003'}
    let(:autauga){'Autauga'}
    let(:baldwin){'Autauga'}
    let(:rate_area_11){11}
    let(:rate_area_12){12}
    let(:silver){'Silver'}
    let(:bronze){'Bronze'}
    let(:rate_12345){'123.45'}
    let(:rate_12346){'123.46'}
    let(:rate_67890){'678.90'}
    let(:plan_id_abc123){'abc123'}
    let(:plan_id_def456){'def456'}
    let(:plan_id_ghi789){'ghi789'}

    let(:zipcode_record_autauga_11){ZipcodeRecord.new(
      zipcode: zipcode_12345,
      state: alabama_code,
      county_code: county_code_01001,
      name: autauga,
      rate_area: rate_area_11,
    )}

    let(:zipcode_record_baldwin_11){ZipcodeRecord.new(
      zipcode: zipcode_12345,
      state: alabama_code,
      county_code: county_code_01003,
      name: baldwin,
      rate_area: rate_area_11,
    )}

    let(:zipcode_record_baldwin_12){ZipcodeRecord.new(
      zipcode: zipcode_12345,
      state: alabama_code,
      county_code: county_code_01003,
      name: baldwin,
      rate_area: rate_area_12,
    )}

    let(:silver_plan_smallest){PlanRecord.new(
      plan_id: plan_id_abc123,
      state: alabama_code,
      metal_level: silver,
      rate: rate_12345,
      rate_area: rate_area_11,
    )}

    let(:silver_plan_highest){PlanRecord.new(
      plan_id: plan_id_def456,
      state: alabama_code,
      metal_level: silver,
      rate: rate_67890,
      rate_area: rate_area_11,
    )}

    let(:bronze_plan_middle){PlanRecord.new(
      plan_id: plan_id_ghi789,
      state: alabama_code,
      metal_level: bronze,
      rate: rate_12346,
      rate_area: rate_area_11,
    )}

    let(:slcsp_record){SlcspRecord.new(
      zipcode: zipcode_12345,
    )}

    it 'sets its rate from supplied data' do
      slcsp_record.set_rate!(
        zip_records: [zipcode_record_autauga_11],
        plan_records: [silver_plan_smallest, silver_plan_highest],
      )

      expect(slcsp_record.rate).to eql(silver_plan_highest.rate)
    end

    it 'sets no rate if there is only one plan' do
      slcsp_record.set_rate!(
        zip_records: [zipcode_record_autauga_11],
        plan_records: [silver_plan_smallest],
      )

      expect(slcsp_record.rate).to be_nil
    end

    it 'looks for the second lowest rate by unique values' do
      slcsp_record.set_rate!(
        zip_records: [zipcode_record_autauga_11],
        plan_records: [silver_plan_smallest, silver_plan_smallest, silver_plan_highest],
      )

      expect(slcsp_record.rate).to eql(silver_plan_highest.rate)
    end

    it 'ignores non-silver plans' do
      slcsp_record.set_rate!(
        zip_records: [zipcode_record_autauga_11],
        plan_records: [silver_plan_smallest, bronze_plan_middle, silver_plan_highest],
      )

      expect(slcsp_record.rate).to eql(silver_plan_highest.rate)
    end

    it 'can handle when a zipcode covers more than one county, but the rate area is still determinable' do
      slcsp_record.set_rate!(
        zip_records: [zipcode_record_autauga_11, zipcode_record_baldwin_11],
        plan_records: [silver_plan_smallest, silver_plan_highest],
      )

      expect(slcsp_record.rate).to eql(silver_plan_highest.rate)
    end

    it 'does not set a rate if the zipcode is in more than one rate area' do
      slcsp_record.set_rate!(
        zip_records: [zipcode_record_autauga_11, zipcode_record_baldwin_12],
        plan_records: [silver_plan_smallest, silver_plan_highest],
      )

      expect(slcsp_record.rate).to be_nil
    end

  end

end

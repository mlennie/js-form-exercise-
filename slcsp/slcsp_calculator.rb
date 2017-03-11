require 'csv'

class SlcspCalculator

  # slcsp.csv
  # row[0]: zipcode
  # row[1]: rate

  # zips.csv
  # row[0]: zipcode
  # row[1]: state
  # row[2]: county_code
  # row[3]: name
  # row[4]: rate_area

  # plans.csv
  # row[0]: plan_id
  # row[1]: state
  # row[2]: metal_level
  # row[3]: rate
  # row[4]: rate_area

  def self.find_rate_areas zipcode
    combined_rate_areas = []
    CSV.foreach("./zips.csv") do |row|
      combined_rate_areas << row[1] + "," + row[4] if row[0] == zipcode
    end
    return combined_rate_areas.uniq
  end

  def self.conditions_match_for_rate row, rate_area
    rate_area.split(",")[0] == row[1] &&
    rate_area.split(",")[1] == row[4] &&
    row[2] == "Silver" &&
    row[3] && row[3].length > 0
  end

  def self.find_rate_by_rate_area rate_area
    rates = []
    CSV.foreach("./plans.csv") do |row|
      rates << row[3] if self.conditions_match_for_rate(row, rate_area)
    end
    new_rates = rates.uniq.sort_by(&:to_f)
    puts new_rates
    new_rates[1]
  end

  def self.find_rate_for_single_zipcode row
    new_row = {zipcode: row[0], rate: nil}
    # get combined rate_area "state,number"
    rate_areas = self.find_rate_areas row[0]
    # if more than one rate_area, rate should be blank
    return new_row if rate_areas.length > 1
    # find second lowest unique silver rate for single combined rate area
    rate = self.find_rate_by_rate_area rate_areas[0]
    new_row[:rate] = rate if rate && rate.length > 0
    puts new_row
    new_row
  end

  def self.create_csv_with_rates hashes
    column_names = hashes.first.keys
    s=CSV.generate do |csv|
      csv << column_names
      hashes.each do |x|
        csv << x.values
      end
    end
    File.write('complete_slcsp.csv', s)
  end

  def self.find_rates_for_all
    new_zips_with_rates = []
    CSV.foreach("./slcsp.csv") do |row|
      new_zips_with_rates << self.find_rate_for_single_zipcode(row)
    end
    puts new_zips_with_rates
    new_zips_with_rates.shift
    self.create_csv_with_rates new_zips_with_rates
  end

end

SlcspCalculator.find_rates_for_all

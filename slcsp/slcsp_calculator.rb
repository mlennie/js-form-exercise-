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

  def self.parse_plans_csv
    rows = []
    CSV.foreach("./plans.csv") do |row|
      hash = {
        plan_id: row[0],
        state: row[1],
        metal_level: row[2],
        rate: row[3],
        rate_area: row[4]
      }
      rows << hash
    end
    rows
  end

  def self.find_rate_areas zipcode
    rate_areas = []
    county_codes = []
    states = []
    combined_rate_areas = []

    CSV.foreach("./zips.csv") do |row|
      if row[0] == zipcode
        rate_areas << row[4]
        county_codes << row[2]
        states << row[1]
        combined_rate_areas << row[1] + "," + row[4]
      end
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

  def self.find_rates_for_all
    new_zips = []
    CSV.foreach("./slcsp.csv") do |row|
      new_zips << self.find_rate_for_single_zipcode row
    end
    puts new_zips
  end

end

SlcspCalculator.find_rates_for_all

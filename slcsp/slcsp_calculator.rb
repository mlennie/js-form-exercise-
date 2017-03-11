require 'csv'

class SlcspCalculator

  def self.parse_zipcodes_csv
    rows = []
    CSV.foreach("./slcsp.csv") do |row|
      rows << {zipcode: row[0]}
    end
    rows
  end

  def self.parse_rate_areas_csv
    rows = []
    CSV.foreach("./zips.csv") do |row|
      hash = {
        zipcode: row[0],
        state: row[1],
        county_code: row[2],
        name: row[3],
        rate_area: row[4]
      }
      rows << hash
    end
    rows
  end

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

  def self.find_rate_areas_and_county_codes zipcode
    rate_areas = []
    county_codes = []
    CSV.foreach("./zips.csv") do |row|
      if row[0] == zipcode
        rate_areas << row[4]
        county_codes << row[2]
      end
    end
    return {rate_areas: rate_areas, county_codes: county_codes}
  end

  def self.find_slcsp_from_rates rates
  end

  def self.find_rates_by_county_codes_or_rate_areas rate_and_counties
    rates = []
    CSV.foreach("./plans.csv") do |row|
      if rate_and_counties[:rate_area] == row[4] &&
         row[2] == "Silver" &&
         row[3] && row[3].length > 0
        rates << row[3]
      end
      rate_and_counties[:rates] = rates.sort_by(&:to_f)
      rate_and_counties[:rate] = rate_and_counties[:rates][1]

      # said can find by counties but plans.csv does not have counties
      #rate_and_counties[:county_codes].each do |county|
        #if row[]
      #end
    end
    return rate_and_counties
  end

  def self.find_rates
    new_zips = []
    CSV.foreach("./slcsp.csv") do |row|
      rate_areas_and_county_codes = self.find_rate_areas_and_county_codes row[0]
      rate_areas = rate_areas_and_county_codes[:rate_areas]
      # if more than one rate_area, rate should be blank
      if rate_areas.length > 1
        new_row = {zipcode: row[0], rate: nil}
      else
        county_codes = rate_areas_and_county_codes[:county_codes]
        new_row = { zipcode: row[0], rate_area: rate_areas[0], county_codes: county_codes }
        new_row = self.find_rates_by_county_codes_or_rate_areas new_row
        new_row.delete(:county_codes)
        new_row.delete(:rate_area)
      end
      puts new_row
      new_zips << new_row
    end
    puts new_zips
  end

end

SlcspCalculator.find_rates

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

  def self.find_rates_by_county_codes_or_rate_areas rate_and_counties
    CSV.foreach("./plans.csv") do |row|
      rate_and_counties[:county_codes].each do |county|

      end
    end
  end

  def self.match_zipcodes
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
      end
      puts new_row
      new_zips << new_row
    end
    puts new_zips
  end

  def self.parse_slcsp
    #zipcodes_array = self.parse_zipcodes_csv
    #rate_areas_array = self.parse_rate_areas_csv
    #plans_array = self.parse_plans_csv
    matched_zipcodes = self.match_zipcodes
  end
end

SlcspCalculator.parse_slcsp

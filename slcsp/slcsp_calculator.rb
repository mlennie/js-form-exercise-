require 'csv'

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

def create_csv_with_rates hashes
  # generate complete csv
  column_names = hashes.first.keys
  s=CSV.generate do |csv|
    csv << column_names
    hashes.each do |x|
      csv << x.values
    end
  end
  File.write('complete_slcsp.csv', s)
  puts "new complete_slcsp.csv file created with zipcodes and rates"
end

def find_rate_areas zipcode
  combined_rate_areas = []
  CSV.foreach("./zips.csv") do |row|
    # if matches zipcode, get combined rate_area (state and number)
    combined_rate_areas << row[1] + "," + row[4] if row[0] == zipcode
  end
  return combined_rate_areas.uniq
end

def conditions_match_for_rate row, rate_area
  # rate must have same rate_area, be silver and must have a rate
  rate_area.split(",")[0] == row[1] &&
  rate_area.split(",")[1] == row[4] &&
  row[2] == "Silver" &&
  row[3] && row[3].length > 0
end

def find_rate_by_rate_area rate_area
  rates = []
  CSV.foreach("./plans.csv") do |row|
    # add rate if conditions match
    rates << row[3] if conditions_match_for_rate(row, rate_area)
  end
  # get unique, sort and return second lowest
  rates.uniq.sort_by(&:to_f)[1]
end

def find_rate_for_single_zipcode row
  new_row = {zipcode: row[0], rate: nil}
  # get combined rate_area "state,number"
  rate_areas = find_rate_areas row[0]
  # if more than one rate_area, rate should be blank
  return new_row if rate_areas.length > 1
  # find second lowest unique silver rate for single combined rate area
  new_row[:rate] = find_rate_by_rate_area rate_areas[0]
  puts "rate processed:"
  puts new_row
  new_row
end

def find_rates_for_all
  # get rates for zips
  new_zips_with_rates = []
  CSV.foreach("./slcsp.csv") do |row|
    new_zips_with_rates << find_rate_for_single_zipcode(row)
  end
  new_zips_with_rates.shift
  # generate new csv with rates
  create_csv_with_rates new_zips_with_rates
end

find_rates_for_all

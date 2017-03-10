require 'csv'

class SlcspCalculator

  def self.get_zipcodes
    rows = []
    CSV.foreach("./slcsp.csv") do |row|
      rows << {zipcode: row[0]}

      zips = CSV.table("./zips.csv", converters: :all)
      pulled_zip_row = zips.find  do |zip_row|
            zip_row.field(:zipcode) == row[0]
      end

      puts pulled_zip_row

    end
    rows
  end

  def self.parse_slcsp
    self.get_zipcodes
  end
end

SlcspCalculator.parse_slcsp

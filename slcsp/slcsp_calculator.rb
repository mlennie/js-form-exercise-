require 'csv'

class SlcspCalculator

  def self.parse_slcsp
    CSV.foreach("./slcsp.csv") do |row|
      puts row.inspect
    end
  end
end

SlcspCalculator.parse_slcsp

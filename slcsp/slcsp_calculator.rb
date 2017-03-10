require 'csv'
require 'yaml'

class SlcspCalculator

  def self.parse_slcsp
    CSV.foreach("./slcsp.csv") do |row|
      puts YAML.load(row.inspect)[0]
    end
  end
end

SlcspCalculator.parse_slcsp

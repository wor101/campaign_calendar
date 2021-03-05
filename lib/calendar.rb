require 'bundler/setup'
require 'yaml'

class Year
  attr_reader :number, :name, :type, :months
  
  def initialize(number, name, type, months = 12)
    @number = number
    @name = name
    @type = type
    @months = months
  end
end

class Month
  attr_reader :number, :name, :description, :gregorian, :days
  
  def initialize(number, name, description, gregorian, days)
    @number = number
    @name = name
    @description = description
    @gregorian = gregorian
    @days = days
  end
end

class Week
  
  def initialize(number, days, name = '', description = '')
    @number = number
    @days = days
    @name = name
    @description = description
  end
end

class Day
  
  def initialize(number, name = '', hours = 24)
    @number = number
    @name = name
    @hours = hours
  end
end




class HarptosCalendar
  attr_reader :years, :months
  
  def initialize(year_yaml, month_yaml)
    @years = load_years(year_yaml)
    @months = load_months(month_yaml)
  end
  
  private
  
  def load_years(year_yaml)
    years = []
    year_yaml.each do |year|
      years << Year.new(year["number"], year["name"], year["type"])
    end
    years
  end

  def load_months(month_yaml)

    months = []
    month_yaml.each do |month|
      months << Month.new(month["number"], month["name"], month["description"], month["gregorian"], month["days"])
    end
    months
  end
end

=begin
year_yaml = YAML.load(File.read('year.yaml'))
month_yaml = YAML.load(File.read('month.yaml'))

harptos = HarptosCalendar.new(year_yaml, month_yaml)



puts harptos.months.select { |month| month.number == 6 }.first.name
=end
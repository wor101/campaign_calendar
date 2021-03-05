require 'bundler/setup'
require 'yaml'


class InvalidDate < StandardError ; end

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

class Date
  attr_reader :calendar, :year, :month, :day, :hour, :minutes, :seconds
  
  def initialize(calendar, year = 1367, month = 1, day = 1, hours = 0, minutes = 0, seconds = 0)
    @calendar = calendar
    @year = confirm_year(year)
    @month = month
    @day = day
    @hour = hour
    @minutes = minutes
    @seconds = seconds
  end
  
  private
  
  def confirm_year(year)
    valid_years = calendar.years.map { |year| year.number }
    
    raise InvalidDate if valid_years.none?(year)
    year
  end
  
end


class Calendar
  attr_reader :years, :months, :name
  
  def initialize(year_yaml, month_yaml, name)
    @years = load_years(year_yaml)
    @months = load_months(month_yaml)
    @name = name
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
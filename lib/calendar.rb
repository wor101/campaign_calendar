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
  
  def to_s
    name
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
  
  def to_s
    @name
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
  attr_accessor :calendar, :year, :month, :day, :hour, :minutes, :seconds
  
  def initialize(calendar, year = 1367, month = 1, day = 1, hours = 0, minutes = 0, seconds = 0)
    @calendar = calendar
    @year = confirm_year(year)
    @month = month
    @day = day
    @hour = hour
    @minutes = minutes
    @seconds = seconds
  end
  
  def to_s
    "#{day} #{month} #{year} "
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
  
  def to_s
    @name
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

class TimeKeeper
  SCREEN_WIDTH = 60
  
  attr_reader :date
  
  def initialize(calendar)
    @date = Date.new(calendar)
    @calendar = calendar
  end
  
  def clear_screen
    system 'clear'
  end
  
  def enter_to_continue
    gets.chomp
  end
  
  def greeting
    puts "*"*SCREEN_WIDTH
    puts "Welcome to the #{@calendar} TimeKeeper!".center(SCREEN_WIDTH)
    puts "*"*SCREEN_WIDTH
  end
  
  def main_menu
    selection = ''
    loop do
      puts " 1. Set Current Date"
      selection = gets.chomp.to_i
      break if [1].include?(selection)
    end
    case selection
    when 1 then set_date_menu
    end
  end
  
  def set_date_menu
    clear_screen
    set_year
    set_month
    set_day
    display_full_date
  end

  def set_year
    input_year = nil
    
    loop do
      valid_years = @calendar.years.map { |year| year.number.to_i }
      puts "Please enter a year between: #{valid_years.first.to_s} and #{valid_years.last.to_s}"
      input_year = gets.chomp.to_i
      break if valid_years.include?(input_year)
      clear_screen
      puts "Sorry #{input_year} is not a valid year."
    end
    @date.year = @calendar.years.select { |year| year.number == input_year }[0]
    clear_screen
    puts "You selected the year #{date.year.number} #{date.year.type} '#{date.year.name}'"
    enter_to_continue
  end
  
  def set_month
    clear_screen
    set_month_header

    months = @calendar.months
    valid_months = months.map { |month| month.number.to_s }
    input_month = nil
    
    loop do
      puts "Please select from one of the months below:"
      months.each do |month|
        puts "#{month.number}. #{month.name}"
      end
      input_month = gets.chomp
     
      break if valid_months.include?(input_month)
      clear_screen
      set_month_header
      puts "Sorry that's not a valid month. Please select using the month's number.\r\n\r\n"
    end
    date.month = months.select { |month| month.number.to_s == input_month }.first
    puts "You selected #{date.month.name}"
  end
  
  def set_month_header
    puts "*"*SCREEN_WIDTH
    puts "#{date.year.number} '#{date.year.name}'".center(SCREEN_WIDTH)
    puts "*"*SCREEN_WIDTH
  end
  
  def set_day
    clear_screen
    set_day_header
    valid_days = (1..date.month.days)
    input_day = nil
    
    loop do
      puts "Please select the current day"
      puts "Valid days in #{date.month} are between 1 and #{date.month.days}"
      input_day = gets.chomp.to_i
      break if valid_days.include?(input_day)
      clear_screen
      set_day_header
      puts "Sorry that is not a valid day.\r\n\r\n"
    end
    date.day = input_day
  end
  
  def set_day_header
    puts "*"*SCREEN_WIDTH
    puts "#{date.month.name} of #{date.year.number} '#{date.year.name}'".center(SCREEN_WIDTH)
    puts "*"*SCREEN_WIDTH
  end
  
  def display_full_date
    puts "#{date.day} #{date.month.name} #{date.year.number}#{date.year.type} '#{date.year.name}'".center(SCREEN_WIDTH)
  end
  
  def start
    loop do
      greeting
      main_menu
      break
    end
  end
end

# load YAML data fiels
year_yaml = YAML.load(File.read('year.yaml'))
month_yaml = YAML.load(File.read('month.yaml'))

# instantiate calendar object
harptos = Calendar.new(year_yaml, month_yaml, "Harptos")



TimeKeeper.new(harptos).start

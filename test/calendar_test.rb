require 'minitest/autorun'

require_relative '../lib/calendar'


class CalendarTest < Minitest::Test
  attr_reader :year_yaml, :month_yaml, :calendar, :date
  
  def setup
    @year_yaml = YAML.load(File.read('../lib/year.yaml'))
    @month_yaml = YAML.load(File.read('../lib/month.yaml'))
    @calendar = Calendar.new(year_yaml, month_yaml, 'Harptos')
    @date = Date.new(calendar)
  end
  
  def test_months_are_month_objects
    random_month = calendar.months.sample
    assert_instance_of(Month, random_month)
  end
  
  def test_date_exists
    assert_instance_of(Date, date)
  end
  
  def test_date_calendar
    assert_instance_of(Calendar, date.calendar)
  end
  
  def test_invalid_date
    assert_raises(InvalidDate) { Date.new(calendar, 2021) }
  end
  
  
end

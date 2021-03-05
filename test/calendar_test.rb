require 'minitest/autorun'

require_relative '../lib/calendar'


class CalendarTest < Minitest::Test
  attr_reader :year_yaml, :month_yaml, :harptos
  
  def setup
    @year_yaml = YAML.load(File.read('../lib/year.yaml'))
    @month_yaml = YAML.load(File.read('../lib/month.yaml'))
    @harptos = HarptosCalendar.new(year_yaml, month_yaml)
  end
  
  def test_months_are_month_objects
    random_month = harptos.months.sample
    assert_instance_of(Month, random_month)
  end
  
  
end

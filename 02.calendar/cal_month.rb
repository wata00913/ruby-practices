require 'date'

class Month
  attr_reader :year, :mon

  def initialize(year, mon)
    @year = year
    @mon = mon
    @last_day = Date.new(@year, @mon, -1).day
    @weeks = []
    init_weeks
  end

  def weeks
    @weeks.each { |week| yield week.values }
  end

  private

  def init_weeks
    d = 1
    while d <= @last_day
      week = { 0 => nil,
               1 => nil,
               2 => nil,
               3 => nil,
               4 => nil,
               5 => nil,
               6 => nil }

      week.each_key do |wday|
        break if d > @last_day

        if wday == day_of_week(d)
          week[wday] = d
          d += 1
        end
      end
      @weeks.push(week)
    end
  end

  def day_of_week(day)
    Date.new(@year, @mon, day).wday
  end
end

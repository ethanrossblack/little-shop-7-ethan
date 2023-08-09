require "faraday"
require "./app/poros/holiday"

class HolidayService
  def get_next_3_holidays
    response = connection.get
    parsed = JSON.parse(response.body, symbolize_names: true)

    holidays = []
    i = 0
    3.times do
      holidays << Holiday.new(parsed[i])
      i += 1
    end
    holidays
  end

  def connection
    Faraday.new(url:"https://date.nager.at/api/v3/NextPublicHolidays/US")
  end
end

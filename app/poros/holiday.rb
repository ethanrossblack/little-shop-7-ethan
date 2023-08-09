class Holiday
  attr_reader :name, :date

  def initialize(data)
    @name = data[:localName]
    @date = Date.parse(data[:date])
  end
end

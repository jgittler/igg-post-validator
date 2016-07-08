class CsvParser
  ENCODING = "iso-8859-1:utf-8"
  ROW_OFFSET = 2

  def initialize(file)
    @csv = CSV.read(file, encoding: ENCODING)
    @headers = @csv.first
  end

  def to_hashes
    csv[1..-1].each_with_index.map do |row, idx|
      { (idx + ROW_OFFSET) => headers.zip(row).to_h }
    end 
  end

  private
  attr_reader :csv, :headers
end

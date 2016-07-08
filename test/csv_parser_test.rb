require_relative "../lib/csv_parser.rb"

class CsvParserTest < MiniTest::Test
  def setup
    @parser = CsvParser.new("csv/Free Pair or Warranty.csv")
  end

  def csv_data
    [
      { 2 => {
        "Timestamp"=>"2016/06/27 4:41:56 AM MDT",
        "What email did you use when claiming your perk on Indiegogo?"=>"chriskim06@gmail.com",
        "Choose 1 of the following perks."=>"Free Pair",
        "Submit the url of your publicly shared post."=>"https://www.facebook.com/1",
        "Black Fantom"=>"",
        "Tortoise Fantom"=>"",
        "Black Konvoy"=>"1",
        "Tortoise Konvoy"=>"",
        "Ice Blue Heron"=>"",
        "Dark Green Heron"=>""}
      },
      { 3 => {
        "Timestamp"=>"2016/06/27 5:15:26 AM MDT",
        "What email did you use when claiming your perk on Indiegogo?"=>"greg.b.swanson@gmail.com",
        "Choose 1 of the following perks."=>"Lifetime Warranty",
        "Submit the url of your publicly shared post."=>"https://www.facebook.com/2",
        "Black Fantom"=>"",
        "Tortoise Fantom"=>"",
        "Black Konvoy"=>"",
        "Tortoise Konvoy"=>"",
        "Ice Blue Heron"=>"",
        "Dark Green Heron"=>""}
      }
    ]
  end

  def test_to_hashes
    assert_equal csv_data, @parser.to_hashes
  end
end

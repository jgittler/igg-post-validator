require "ostruct"
require_relative "../lib/backer.rb"

class BackerTest < MiniTest::Test
  def before_setup
    super

    system "rake db:test:down"
  end

  def test_insert_with_no_errors
    Backer.insert(backer: backer_1, request: request, success: true)

    b = Backer.find_by(on_rescue: false)

    assert_equal "Free Pair", b.perk
    assert_equal true, b.successful?
  end

  def test_insert_with_email_error
    Backer.insert(backer: backer_2, request: request, success: true)

    b = Backer.find_by(on_rescue: false)

    assert_equal "Free Pair", b.perk
    assert_equal false, b.successful?
    assert_equal "Failed valid email format", b.error_desc
  end

  def test_insert_with_invalid_option
    Backer.insert(backer: backer_3, request: request, success: true)

    b = Backer.find_by(on_rescue: false)

    assert_equal "Lifetime Warranty", b.perk
    assert_equal false, b.successful?
    assert_equal "Specified pairs when Lifetime Warranty was also chosen", b.error_desc
  end

  def test_insert_with_missing_pair
    Backer.insert(backer: backer_4, request: request, success: true)

    b = Backer.find_by(on_rescue: false)

    assert_equal "Free Pair", b.perk
    assert_equal false, b.successful?
    assert_equal "Forgot to specify a free pair(s)", b.error_desc
  end

  def test_insert_with_invalid_url
    Backer.insert(backer: backer_5, request: request, success: false)
    
    b = Backer.find_by(on_rescue: false)

    assert_equal "Free Pair", b.perk
    assert_equal false, b.successful?
    assert_equal "Submitted a url that isn't from facebook", b.error_desc
  end

  def test_backer_pairs
    pair_hash = Backer::PAIRS_MATRIX.keys.each_with_index.map do |pair, i|
      [pair, i]
    end.to_h
    b = Backer.create!(pair_hash)

    assert_equal "
1 Tortoise Fantom(s)
2 Black Konvoy(s)
3 Tortoise Konvoy(s)
4 Ice Blue Heron(s)
5 Dark Green Heron(s)", b.pretty_pairs
  end

  def test_uniq_url
    Backer.create(email: "jason@gmail.com")
    b = Backer.new(email: "jason@gmail.com")

    assert_equal false, b.valid?
  end

  def test_uniq_email
    Backer.create(post_url: "facebook.com")
    b = Backer.new(post_url: "facebook.com")

    assert_equal false, b.valid?
  end

  def backer_1
    { 2 => {
      "Timestamp"=>"2016/06/27 4:41:56 AM MDT",
      "What email did you use when claiming your perk on Indiegogo?"=>"rog@elitepromo.com",
      "Choose 1 of the following perks."=>"Free Pair",
      "Submit the url of your publicly shared post."=>"https://www.facebook.com",
      "Black Fantom"=>"",
      "Tortoise Fantom"=>"",
      "Black Konvoy"=>"1",
      "Tortoise Konvoy"=>"",
      "Ice Blue Heron"=>"",
      "Dark Green Heron"=>""}
    }
  end

  def backer_2
    { 2 => {
      "Timestamp"=>"2016/06/27 4:41:56 AM MDT",
      "What email did you use when claiming your perk on Indiegogo?"=>"jake.gmail.com",
      "Choose 1 of the following perks."=>"Free Pair",
      "Submit the url of your publicly shared post."=>"https://www.facebook.com",
      "Black Fantom"=>"",
      "Tortoise Fantom"=>"",
      "Black Konvoy"=>"1",
      "Tortoise Konvoy"=>"",
      "Ice Blue Heron"=>"",
      "Dark Green Heron"=>""}
    }
  end

  def backer_3
    { 2 => {
      "Timestamp"=>"2016/06/27 4:41:56 AM MDT",
      "What email did you use when claiming your perk on Indiegogo?"=>"rog@elitepromo.com",
      "Choose 1 of the following perks."=>"Lifetime Warranty",
      "Submit the url of your publicly shared post."=>"https://www.facebook.com",
      "Black Fantom"=>"",
      "Tortoise Fantom"=>"",
      "Black Konvoy"=>"1",
      "Tortoise Konvoy"=>"",
      "Ice Blue Heron"=>"",
      "Dark Green Heron"=>""}
    }
  end

  def backer_4
    { 2 => {
      "Timestamp"=>"2016/06/27 4:41:56 AM MDT",
      "What email did you use when claiming your perk on Indiegogo?"=>"rog@elitepromo.com",
      "Choose 1 of the following perks."=>"Free Pair",
      "Submit the url of your publicly shared post."=>"https://www.facebook.com",
      "Black Fantom"=>"",
      "Tortoise Fantom"=>"",
      "Black Konvoy"=>"",
      "Tortoise Konvoy"=>"",
      "Ice Blue Heron"=>"",
      "Dark Green Heron"=>""}
    }
  end

  def backer_5
    { 2 => {
      "Timestamp"=>"2016/06/27 4:41:56 AM MDT",
      "What email did you use when claiming your perk on Indiegogo?"=>"rog@elitepromo.com",
      "Choose 1 of the following perks."=>"Free Pair",
      "Submit the url of your publicly shared post."=>"https://www.google.com",
      "Black Fantom"=>"",
      "Tortoise Fantom"=>"",
      "Black Konvoy"=>"1",
      "Tortoise Konvoy"=>"",
      "Ice Blue Heron"=>"",
      "Dark Green Heron"=>""}
    }
  end

  def request
    OpenStruct.new(code: 200)
  end
end

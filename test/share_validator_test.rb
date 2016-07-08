require_relative "../lib/share_validator.rb"
require_relative "../lib/backer.rb"
require_relative "./request_stubs.rb"

class ShareValidatorTest < MiniTest::Test
  def before_setup
    super

    system "rake db:test:down"
  end

  include RequestStubs

  def test_validate_sucessful_share_title_1
    stub_facebook_200_with_post_earn_second_pair
    ShareValidator.new("csv/Free Pair or Warranty.csv").validate_shares

    assert_equal 2, Backer.where(success: true).count
  end

  def test_validate_sucessful_share_title_2
    stub_facebook_200_with_post_keep_on_giving
    ShareValidator.new("csv/Free Pair or Warranty.csv").validate_shares

    assert_equal 2, Backer.where(success: true).count
  end

  def test_validate_200_failure
    stub_facebook_200_without_post
    ShareValidator.new("csv/Free Pair or Warranty.csv").validate_shares

    assert_equal 0, Backer.where(success: true).count
  end

  def test_validate_failure_404
    stub_facebook_404
    ShareValidator.new("csv/Free Pair or Warranty.csv").validate_shares

    assert_equal 0, Backer.where(success: true).count
  end
end

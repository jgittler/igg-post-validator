class Backer < ActiveRecord::Base
  def self.insert(backer:, request:, success:)
    data = DataConstructor.new(backer, request, success)

    begin
      create(data.construct)
    rescue => e
      create(data.on_rescued(e))
    end
  end

  validates_uniqueness_of :email, :post_url

  PAIRS_MATRIX = {
    b_f: "Black Fantom",
    t_f: "Tortoise Fantom",
    b_k: "Black Konvoy",
    t_k: "Tortoise Konvoy",
    b_h: "Ice Blue Heron",
    g_h: "Dark Green Heron"
  }

  def successful?
    !on_rescue && !error_desc && success
  end

  def perk
    if free_pair
      "Free Pair"
    else
      "Lifetime Warranty"
    end
  end

  def pretty_pairs
    PAIRS_MATRIX.map do |k, v|
      if send(k) && send(k) > 0
        "#{send(k)} #{v}(s)"
      end
    end.join("\n")
  end

  class DataConstructor
    EMAIL_KEY = "What email did you use when claiming your perk on Indiegogo?"

    def initialize(backer, request, success)
      @backer = backer.values[0]
      @request = request
      @success = success
      @row = backer.keys[0]
      @errors = []

      set_error_description!
    end

    def on_rescued(error)
      {
        row: row,
        email: backer[EMAIL_KEY] + "#{Kernel.rand}",
        success: success,
        on_rescue: true,
        created_at: Time.now,
        error_desc: error.inspect
      }
    end

    def construct
      {
        row: row,
        free_pair: free_pair?,
        email: backer[EMAIL_KEY],
        post_url: backer["Submit the url of your publicly shared post."],
        b_f: backer["Black Fantom"],
        t_f: backer["Tortoise Fantom"],
        b_k: backer["Black Konvoy"],
        t_k: backer["Tortoise Konvoy"],
        b_h: backer["Ice Blue Heron"],
        g_h: backer["Dark Green Heron"],
        submission_time: backer["Timestamp"],
        response_code: request.code,
        error_desc: error_description,
        success: success,
        on_rescue: false,
        created_at: Time.now
      }
    end

    private
    attr_reader :request, :backer, :success, :row

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    def error_description
      @errors.empty? ? nil : @errors.join(", ")
    end

    def set_error_description!
      if !free_pair? && includes_pair?
        @errors << "Specified pairs when Lifetime Warranty was also chosen"
      elsif free_pair? && !includes_pair?
        @errors << "Forgot to specify a free pair(s)"
      elsif invalid_emai?
        @errors << "Failed valid email format"
      elsif non_igg_email?
        @errors << "Email is not included in our IGG list"
      elsif free_pair? && wrong_number_claimed?
        @errors << "An incorrect number of pairs were claimed"
      elsif non_facebook_url?
        @errors << "Submitted a url that isn't from facebook"
      end
    end

    def non_igg_email?
      !YAML::load_file("#{APP_ROOT}/backers.yml").fetch(backer[EMAIL_KEY], false)
    end

    def wrong_number_claimed?
      if non_igg_email?
        false
      else
        YAML::load_file("#{APP_ROOT}/backers.yml").fetch(backer[EMAIL_KEY]).to_i != pair_count
      end
    end

    def free_pair?
      backer["Do yo want us to send you free pair(s) now or save your warranty for a later date?"] == "Now"
    end

    def pair_count
      Backer::PAIRS_MATRIX.values.map { |pair| backer[pair].to_i }.reduce(:+)
    end

    def includes_pair?
      pair_count > 0
    end

    def invalid_emai?
      !backer["What email did you use when claiming your perk on Indiegogo?"].match(VALID_EMAIL_REGEX)
    end

    def non_facebook_url?
      !backer["Submit the url of your publicly shared post."].match(/facebook/)
    end
  end
end

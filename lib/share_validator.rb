require_relative "./mailer.rb"
require_relative "./csv_parser.rb"
require_relative "./backer.rb"

class ShareValidator
  URL_KEY = "Submit the url of your publicly shared post."

  def initialize(file)
    @backers = CsvParser.new(file).to_hashes
  end

  def validate_shares
    backers.each do |backer|
      validate(backer)
    end
  end

  private
  attr_reader :backers

  def validate(backer)
    request = Request[backer.values[0][URL_KEY]]

    if request.success?
      b = Backer.insert(backer: backer, request: request, success: true)

      if b.successful? #&& production?
        ::Mailer.successful_post_validation("jason.gittler@gmail.com", b.perk, b.pretty_pairs).deliver_now
        # ::Mailer.successful_post_validation(b.email, b.perk, b.pretty_pairs).deliver_now
      end
    else
      Backer.insert(backer: backer, request: request, success: false)
    end
  end

  class Request
    CAMPAIGN_TITLES = [
      "Earn a second pair for free.",
      "The Glasses that keep on Giving."
    ]

    class << self
      def [](uri)
        new(HTTParty.get(url(uri.downcase))).parse
      end

      def url(uri)
        if uri.match(/http/)
          uri
        else
          "https://" + uri
        end
      end
    end

    attr_reader :code
    def initialize(response)
      @response = response.body
      @code = response.code
      @success = false
    end

    def parse
      if code == 200 && contains_required_text?
        @success = true
      end

      self
    end

    def success?
      success
    end

    private
    attr_reader :response, :success

    def contains_required_text?
      CAMPAIGN_TITLES.any? { |title| response.include?(title) }
    end
  end
end

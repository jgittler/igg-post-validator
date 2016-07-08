require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

module RequestStubs
  include WebMock::API

  RESPONSE_DIR = "test/web_response"

  FB_URL = %r(https://*)
  def stub_facebook_200_with_post_earn_second_pair
    stub_request(:get, FB_URL).to_return(
      status: 200,
      body: File.open(File.join(RESPONSE_DIR, "fb_success_with_post_earn_second_pair.rb"))
    )
  end

  def stub_facebook_200_with_post_keep_on_giving
    stub_request(:get, FB_URL).to_return(
      status: 200,
      body: File.open(File.join(RESPONSE_DIR, "fb_success_with_post_keep_on_giving.rb"))
    )
  end

  def stub_facebook_200_without_post
    stub_request(:get, FB_URL).to_return(
      status: 200,
      body: File.open(File.join(RESPONSE_DIR, "fb_success_with_out_post.rb"))
    )
  end

  def stub_facebook_404
    stub_request(:get, FB_URL).to_return(
      status: 404,
      body: File.open(File.join(RESPONSE_DIR, "fb_not_found.rb"))
    )
  end
end
